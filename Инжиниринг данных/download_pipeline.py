import luigi
import os
import wget
import tarfile
import gzip
import io
import pandas as pd
import argparse

class DownloadDataset(luigi.Task):
    dataset_name = luigi.Parameter()

    def output(self):
        return luigi.LocalTarget(f'data/{self.dataset_name}/{self.dataset_name}_RAW.tar')

    def run(self):
        # Создаем папку для данных, если ее еще нет
        output_dir = os.path.join('data', self.dataset_name)
        os.makedirs(output_dir, exist_ok=True)

        # Используем wget для скачивания архива
        wget.download(self.archive_url, out=output_dir)

class ExtractAndProcess(luigi.Task):
    dataset_name = luigi.Parameter()

    def requires(self):
        return DownloadDataset(dataset_name=self.dataset_name, archive_url=self.archive_url)

    def output(self):
        return luigi.LocalTarget(f'data/{self.dataset_name}/processed')

    def run(self):
        input_tar = self.input().path
        output_dir = self.output().path

        # Создаем папку для обработанных данных, если ее еще нет
        os.makedirs(output_dir, exist_ok=True)

        # Разархивируем основной архив
        with tarfile.open(input_tar, 'r') as tar:
            # Получаем список файлов в архиве
            file_names = tar.getnames()

            # Создаем подкаталоги и разархивируем файлы
            for file_name in file_names:
                # Извлекаем имя файла без расширения
                base_name = os.path.splitext(os.path.basename(file_name))[0]
                # Создаем подкаталог с именем файла
                file_output_dir = os.path.join(output_dir, base_name)
                os.makedirs(file_output_dir, exist_ok=True)
                # Разархивируем файл в соответствующий подкаталог
                with tar.extractfile(file_name) as tf:
                    with gzip.open(tf, 'rt') as f:
                        content = f.read()

                        # Сохраняем оригинальный текстовый файл в подкаталог processed
                        original_file_path = os.path.join(file_output_dir, f'{base_name}')
                        with open(original_file_path, 'w') as original_file:
                            original_file.write(content)

                        # Если файл - текстовый, разделяем таблицы внутри файла
                        if file_name.endswith('.txt.gz'):
                            print(f"Processing {file_name} into {file_output_dir}")
                            self.process_text_file(file_output_dir, base_name, content)

        # Удаляем .txt файлы (хз как правильно тут сделать :) )
        for root, dirs, files in os.walk(output_dir):
            for file in files:
                if file.endswith('.txt'):
                    os.remove(os.path.join(root, file))

    def process_text_file(self, directory, file_name, content):
        dfs = {}
        fio = io.StringIO(content)
        write_key = None

        # Извлекаем имя файла без расширения для подкаталога
        base_name = os.path.splitext(os.path.basename(file_name))[0]

        # Создаем подкаталог с именем файла
        file_output_dir = os.path.join(directory, base_name)
        os.makedirs(file_output_dir, exist_ok=True)

        # Воруем код
        with fio:
            for line in fio.readlines():
                if line.startswith('['):
                    if write_key:
                        fio.seek(0)
                        header = None if write_key == 'Heading' else 'infer'
                        dfs[write_key] = pd.read_csv(fio, sep='\t', header=header)
                    fio = io.StringIO()
                    write_key = line.strip('[]\n')
                    continue
                if write_key:
                    fio.write(line)

            fio.seek(0)
            dfs[write_key] = pd.read_csv(fio, sep='\t')

        # Сохраняем каждый df в отдельный tsv-файл внутри подкаталога
        for key, df in dfs.items():
            # Ещё раз хз как тут правильно сделать
            if key == 'Probes':
                # Сохраняем оригинальный df в файл Probes.tsv
                df.to_csv(os.path.join(file_output_dir, f'{key}.tsv'), sep='\t', index=False)

                # Урезаем df и сохраняем в файл Probes_reduced.tsv ???
                reduced_df = df.drop(['Definition', 'Ontology_Component', 'Ontology_Process', 
                                      'Ontology_Function', 'Synonyms', 'Obsolete_Probe_Id', 
                                      'Probe_Sequence'], axis=1)
                reduced_df.to_csv(os.path.join(file_output_dir, f'{key}_reduced.tsv'), sep='\t', index=False)

            else:
                # Сохраняем каждый df, кроме Probes, в отдельный tsv-файл
                df.to_csv(os.path.join(file_output_dir, f'{key}.tsv'), sep='\t', index=False)

if __name__ == '__main__':
    # Парсим аргументы (имя архива тоже аргумент)
    parser = argparse.ArgumentParser(description='Download and process dataset.')
    parser.add_argument('--dataset_name', type=str, help='Name of the dataset')
    parser.add_argument('--archive_url', type=str, help='URL of the dataset archive')

    args = parser.parse_args()

    luigi.build([ExtractAndProcess(dataset_name=args.dataset_name, archive_url=args.archive_url)], local_scheduler=True)