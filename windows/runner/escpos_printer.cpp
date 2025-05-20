#include <Windows.h>
#include <string>
#include <vector>
#include <winspool.h>

bool PrintRawDataToUSBPrinter(const std::vector<uint8_t>& data, const std::wstring& printerName) {
    // Open printer
    HANDLE hPrinter;
    if (!OpenPrinterW((LPWSTR)printerName.c_str(), &hPrinter, NULL)) {
        std::wcerr << L"[ERROR] Failed to open printer: " << printerName << std::endl;
        return false;
    }

    // Create a DOC_INFO_1 structure
    DOC_INFO_1 docInfo;
    docInfo.pDocName = (LPWSTR)L"ESC/POS Print Job";
    docInfo.pOutputFile = NULL;
    docInfo.pDatatype = (LPWSTR)L"RAW";

    DWORD jobId = StartDocPrinter(hPrinter, 1, (LPBYTE)&docInfo);
    if (jobId == 0) {
        ClosePrinter(hPrinter);
        std::wcerr << L"[ERROR] Failed to start document" << std::endl;
        return false;
    }

    if (!StartPagePrinter(hPrinter)) {
        EndDocPrinter(hPrinter);
        ClosePrinter(hPrinter);
        std::wcerr << L"[ERROR] Failed to start page" << std::endl;
        return false;
    }

    DWORD bytesWritten;
    BOOL success = WritePrinter(hPrinter, data.data(), static_cast<DWORD>(data.size()), &bytesWritten);

    EndPagePrinter(hPrinter);
    EndDocPrinter(hPrinter);
    ClosePrinter(hPrinter);

    if (!success || bytesWritten != data.size()) {
        std::wcerr << L"[ERROR] Failed to write all data to printer" << std::endl;
        return false;
    }

    std::wcout << L"[SUCCESS] Data sent to printer" << std::endl;
    return true;
}

