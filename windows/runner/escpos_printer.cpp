#include <windows.h>
#include <iostream>

bool PrintRawDataToUSBPrinter(const std::vector<uint8_t>& data, const std::wstring& printerName) {
    HANDLE hPrinter;
    DOC_INFO_1 docInfo;
    DWORD dwWritten;

    if (!OpenPrinter((LPWSTR)printerName.c_str(), &hPrinter, NULL)) {
        std::wcerr << L"Failed to open printer: " << printerName << std::endl;
        return false;
    }

    docInfo.pDocName = (LPWSTR)L"ESC POS Document";
    docInfo.pOutputFile = NULL;
    docInfo.pDatatype = (LPWSTR)L"RAW";

    if (StartDocPrinter(hPrinter, 1, (LPBYTE)&docInfo) == 0) {
        std::cerr << "StartDocPrinter failed." << std::endl;
        ClosePrinter(hPrinter);
        return false;
    }

    if (!StartPagePrinter(hPrinter)) {
        std::cerr << "StartPagePrinter failed." << std::endl;
        EndDocPrinter(hPrinter);
        ClosePrinter(hPrinter);
        return false;
    }

    if (!WritePrinter(hPrinter, data.data(), data.size(), &dwWritten)) {
        std::cerr << "WritePrinter failed." << std::endl;
        EndPagePrinter(hPrinter);
        EndDocPrinter(hPrinter);
        ClosePrinter(hPrinter);
        return false;
    }

    EndPagePrinter(hPrinter);
    EndDocPrinter(hPrinter);
    ClosePrinter(hPrinter);
    return true;
}
