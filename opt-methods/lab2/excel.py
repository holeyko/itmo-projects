import pandas as pd


class Sheet:
    def __init__(self, name: str, cols: list[str]) -> None:
        self.name = name
        self.cols = cols
        self.rows: list[list] = []

    def add_row(self, row: list[list]) -> None:
        self.rows.append(row)


class ExcellSaver:
    def __init__(self) -> None:
        self._sheets = []
        self._cur_sheets = 0

    def __cur_sheet__(self) -> Sheet:
        return self._sheets[self._cur_sheets]

    def __len__(self):
        return len(self._sheets)

    def __getitem__(self, index: int) -> Sheet:
        if index >= len(self):
            raise Exception('Index out of range [index=' + str(index) + ']')

        return self._sheets[index]

    def add_row(self, row: list) -> None:
        self.__cur_sheet__().add_row(row)

    def add_new_sheet(self, cols: list[str], name: str = '') -> None:
        self._sheets.append(Sheet(name or ('Sheet ' + str(len(self) + 1)), cols))
        self._cur_sheets = len(self) - 1

    def set_sheet(self, index: int) -> None:
        if index >= len(self):
            raise Exception('Index out of range [index=' + str(index) + ']')

        self._cur_sheets = index

    def create_excel(self, path: str = 'result.xlsx') -> None:
        with pd.ExcelWriter(path) as writer:
            for i in range(len(self)):
                df = pd.DataFrame(
                    data=self[i].rows,
                    columns=self[i].cols
                )
                df.to_excel(writer, index=False, sheet_name=self[i].name)
