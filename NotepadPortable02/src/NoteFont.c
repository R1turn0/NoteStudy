#include "NoteFont.h"

static LOGFONT logfont;
static HFONT   hFont;

void FontInit(HWND hwndEdit)
{
    GetObject(GetStockObject(SYSTEM_FONT), sizeof(LOGFONT),
        (PTSTR)&logfont);

    hFont = CreateFontIndirect(&logfont);
    SendMessage(hwndEdit, WM_SETFONT, (WPARAM)hFont, 0);
}

BOOL FontChooseFont(HWND hwnd)
{
    CHOOSEFONT cf;

    cf.lStructSize = sizeof(CHOOSEFONT);                                // �ṹ�ĳ��ȣ����ֽ�Ϊ��λ��
    cf.hwndOwner = hwnd;                                                // ӵ�жԻ���Ĵ��ھ�����˳�Ա�������κ���Ч�Ĵ��ھ������������Ի���û�������ߣ�������ΪNULL ��
    cf.hDC = NULL;                                                      // ��ӡ�����豸�����Ļ���Ϣ�����ľ��
    cf.lpLogFont = &logfont;                                            // 
    cf.iPointSize = 0;                                                  // ��ѡ����Ĵ�С���Ե�� 1/10 Ϊ��λ��
    cf.Flags = CF_INITTOLOGFONTSTRUCT | CF_SCREENFONTS | CF_EFFECTS;    // һ������ڳ�ʼ������Ի����λ��־�����Ի��򷵻�ʱ������������Щ��־��ָʾ�û����롣
    cf.rgbColors = 0;                                                   // ���������CF_EFFECTS��־����rgbColorsָ����ʼ�ı���ɫ��
    cf.lCustData = 0;                                                   
    cf.lpfnHook = NULL;
    cf.lpTemplateName = NULL;
    cf.hInstance = NULL;
    cf.lpszStyle = NULL;
    cf.nFontType = 0;               // Returned from ChooseFont
    cf.nSizeMin = 0;
    cf.nSizeMax = 0;

    return ChooseFont(&cf);
}

void FontSetFont(HWND hwndEdit)
{
    HFONT hFontNew;
    RECT  rect;

    hFontNew = CreateFontIndirect(&logfont);
    SendMessage(hwndEdit, WM_SETFONT, (WPARAM)hFontNew, 0);
    DeleteObject(hFont);
    hFont = hFontNew;
    GetClientRect(hwndEdit, &rect);
    InvalidateRect(hwndEdit, &rect, TRUE);
}

void FontDeinitialize()
{
    DeleteObject(hFont);
}
