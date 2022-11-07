unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, Buttons, ComCtrls, ubarcodes;

type

  { TFrmMain }

  TFrmMain = class(TForm)
    cForeground: TColorButton;
    cBackground: TColorButton;
    cmdSave: TSpeedButton;
    cmdNewList: TSpeedButton;
    cmdAdd: TSpeedButton;
    cmdEdit: TSpeedButton;
    cmdDelete: TSpeedButton;
    cmdOpen: TSpeedButton;
    cmdExportAll: TSpeedButton;
    lstData: TListBox;
    MainMenu1: TMainMenu;
    mnuExportAllImg: TMenuItem;
    mnuExportImage: TMenuItem;
    Separator5: TMenuItem;
    mnuNewLst: TMenuItem;
    nuOpenLst: TMenuItem;
    mnuSaveLst: TMenuItem;
    mnuDelItem: TMenuItem;
    Separator4: TMenuItem;
    Separator3: TMenuItem;
    mnuExit: TMenuItem;
    mnuSave: TMenuItem;
    mnuLst: TPopupMenu;
    Separator2: TMenuItem;
    Separator1: TMenuItem;
    mnuNewList: TMenuItem;
    mnuOpen: TMenuItem;
    mnuFile: TMenuItem;
    qr1: TBarcodeQR;
    cmdExport: TSpeedButton;
    StatusBar1: TStatusBar;
    txtNew: TLabeledEdit;
    txtEdit: TLabeledEdit;
    procedure Button1Click(Sender: TObject);
    procedure cmdDeleteClick(Sender: TObject);
    procedure cmdEditClick(Sender: TObject);
    procedure cmdAddClick(Sender: TObject);
    procedure cmdExportAllClick(Sender: TObject);
    procedure cmdExportClick(Sender: TObject);
    procedure cmdNewListClick(Sender: TObject);
    procedure cmdOpenClick(Sender: TObject);
    procedure cmdSaveClick(Sender: TObject);
    procedure cmdSaveImgClick(Sender: TObject);
    procedure cBackgroundColorChanged(Sender: TObject);
    procedure cForegroundColorChanged(Sender: TObject);
    procedure cmSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstDataClick(Sender: TObject);
    procedure lstDataSelectionChange(Sender: TObject; User: boolean);
    procedure mnuDelItemClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuExportAllImgClick(Sender: TObject);
    procedure mnuExportImageClick(Sender: TObject);
    procedure mnuLstPopup(Sender: TObject);
    procedure mnuNewListClick(Sender: TObject);
    procedure mnuNewLstClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    function GetItemIndex(LBox: TListBox; sFind: string): integer;
    function GetSaveDlgName(nFileExt, nDefaultExt: string): string;
    procedure mnuSaveLstClick(Sender: TObject);
    procedure nuOpenLstClick(Sender: TObject);
    procedure txtEditKeyPress(Sender: TObject; var Key: char);
    procedure txtNewKeyPress(Sender: TObject; var Key: char);
    procedure SavePng(Filename: string);
    procedure SaveJPEG(Filename: string);
    procedure SaveImageToFile();
    procedure SaveAllImages();
    function GetFileTitleOnly(Filename: string): string;
    function FixPath(sPath: string): string;
  private

  public

  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.lfm}

{ TFrmMain }

function TfrmMain.FixPath(sPath: string): string;
begin
  if RightStr(sPath, 1) = PathDelim then
  begin
    Result := sPath;
  end
  else
  begin
    Result := sPath + PathDelim;
  end;
end;

function TFrmMain.GetFileTitleOnly(Filename: string): string;
var
  sPos: integer;
  lzFileName: string;
begin
  lzFileName := ExtractFileName(Filename);

  sPos := LastDelimiter('.', lzFileName);

  if sPos > 0 then
  begin
    Result := LeftStr(lzFileName, sPos - 1);
  end
  else
  begin
    Result := lzFileName;
  end;

end;

procedure TFrmMain.SaveJPEG(Filename: string);
var
  bmp: TBitmap;
  R: TRect;
  jpg: TJPEGImage;
begin
  // bmp, png
  bmp := TBitmap.Create;
  jpg := TJPEGImage.Create;
  jpg.CompressionQuality := 99;
  try
    // bmp
    R := Rect(0, 0, qr1.Width, qr1.Height);
    bmp.SetSize(qr1.Width, qr1.Height);
    bmp.Canvas.Brush.Color := qr1.BackgroundColor;
    bmp.Canvas.FillRect(R);
    qr1.PaintOnCanvas(bmp.Canvas, R);
    // Save png
    jpg.Assign(bmp);
    jpg.SaveToFile(Filename);

  finally
    bmp.Free;
    jpg.Free;
  end;
end;

procedure TFrmMain.SavePng(Filename: string);
var
  bmp: TBitmap;
  R: TRect;
  png: TPortableNetworkGraphic;
begin
  // bmp, png
  bmp := TBitmap.Create;
  png := TPortableNetworkGraphic.Create;

  try
    // bmp
    R := Rect(0, 0, qr1.Width, qr1.Height);
    bmp.SetSize(qr1.Width, qr1.Height);
    bmp.Canvas.Brush.Color := qr1.BackgroundColor;
    bmp.Canvas.FillRect(R);
    qr1.PaintOnCanvas(bmp.Canvas, R);
    // Save png
    png.Assign(bmp);
    png.SaveToFile(Filename);

  finally
    bmp.Free;
    png.Free;
  end;
end;

function TFrmMain.GetItemIndex(LBox: TListBox; sFind: string): integer;
var
  X: integer;
  idx: integer;
begin
  idx := -1;

  for X := 0 to LBox.Count - 1 do
  begin
    if lowercase(LBox.Items[X]) = lowercase(sFind) then
    begin
      idx := X;
      Break;
    end;
  end;
  Result := idx;
end;

procedure TFrmMain.SaveImageToFile();
var
  sd: TSaveDialog;
begin
  sd := TSaveDialog.Create(self);
  sd.Title := 'Export Image';
  sd.Filter := 'Bitmap Files(*.bmp)|*.bmp|PNG Files(*.png)|*.png|JPEG Files(*.jpeg)|*.jpeg';
  sd.DefaultExt := 'bmp';
  if sd.Execute then
  begin
    case sd.FilterIndex of
      1:
      begin
        qr1.SaveToFile(sd.FileName);
      end;
      2:
      begin
        SavePng(sd.FileName);
      end;
      3:
      begin
        SaveJPEG(sd.FileName);
      end;
    end;
  end;
  sd.Destroy;
end;

procedure TFrmMain.SaveAllImages();
var
  sd: TSaveDialog;
  I: integer;
  lzDir: string;
  lzFile: string;
  lzExt: string;
  lzRealName: string;
begin
  sd := TSaveDialog.Create(self);
  sd.Title := 'Export All Images';
  sd.Filter := 'Bitmap Files(*.bmp)|*.bmp|PNG Files(*.png)|*.png|JPEG Files(*.jpeg)|*.jpeg';
  sd.DefaultExt := 'bmp';

  if sd.Execute then
  begin
    lzDir := FixPath(ExtractFileDir(sd.FileName));
    lzFile := ExtractFilename(GetFileTitleOnly(sd.FileName));
    lzExt := ExtractFileExt(sd.FileName);

    for I := 0 to lstData.Count - 1 do
    begin
      //Real filename
      lzRealName := lzDir + lzFile + '_' + IntToStr(I + 1) + lzExt;
      //Update qr code text
      qr1.Text := lstData.Items[I];
      //Image format filters
      case sd.FilterIndex of
        1:
        begin
          //Default BMP
          qr1.SaveToFile(lzRealName);
        end;
        2:
        begin
          //Png
          SavePng(lzRealName);
        end;
        3:
        begin
          //Jpeg
          SaveJPEG(lzRealName);
        end;
      end;
    end;
  end;
  sd.Destroy;
end;

function TFrmMain.GetSaveDlgName(nFileExt, nDefaultExt: string): string;
var
  sd: TSaveDialog;
  lzFile: string;
begin
  sd := TSaveDialog.Create(self);
  sd.Title := 'Save';
  sd.Filter := nFileExt;
  sd.DefaultExt := nDefaultExt;
  if sd.Execute then
  begin
    lzFile := sd.FileName;
  end;
  sd.Destroy;
  Result := lzFile;
end;

procedure TFrmMain.mnuSaveLstClick(Sender: TObject);
begin
  mnuSaveClick(Sender);
end;

procedure TFrmMain.nuOpenLstClick(Sender: TObject);
begin
  mnuOpenClick(Sender);
end;

procedure TFrmMain.txtEditKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    Key := #0;
    cmdEditClick(Sender);
  end;
end;

procedure TFrmMain.txtNewKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then
  begin
    Key := #0;
    cmdAddClick(Sender);
  end;
end;

procedure TFrmMain.cmdSaveImgClick(Sender: TObject);
begin
  qr1.ForegroundColor := clRed;
end;

procedure TFrmMain.cmdAddClick(Sender: TObject);
var
  sItem: string;
begin
  if Trim(txtNew.Text) <> '' then
  begin
    sItem := txtNew.Text;
    lstData.Items.Add(sItem);
    lstData.ItemIndex := GetItemIndex(lstData, sItem);
    lstDataClick(Sender);
    txtNew.Clear;
  end;
end;

procedure TFrmMain.cmdExportAllClick(Sender: TObject);
begin
  if lstData.Count > 0 then
  begin
    SaveAllImages();
  end;
end;

procedure TFrmMain.cmdExportClick(Sender: TObject);
begin
  if lstData.ItemIndex > -1 then
    SaveImageToFile;
end;

procedure TFrmMain.cmdNewListClick(Sender: TObject);
begin
  mnuNewListClick(Sender);
end;

procedure TFrmMain.cmdOpenClick(Sender: TObject);
begin
  mnuOpenClick(Sender);
end;

procedure TFrmMain.cmdSaveClick(Sender: TObject);
begin
  mnuSaveClick(Sender);
end;

procedure TFrmMain.cmdEditClick(Sender: TObject);
begin
  if lstData.ItemIndex > -1 then
  begin
    if trim(txtEdit.Text) <> '' then
    begin
      lstData.Items[lstData.ItemIndex] := txtEdit.Text;
      lstDataClick(Sender);
    end;
  end;
end;

procedure TFrmMain.cmdDeleteClick(Sender: TObject);
begin
  if lstData.ItemIndex > -1 then
  begin
    if MessageDlg(Text, 'Are you sure you want to delete this item?',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      lstData.Items.Delete(lstData.ItemIndex);
      lstData.Update;
      cmdDelete.Enabled := False;
      mnuDelItem.Enabled := False;
      cmdExport.Enabled := False;
      qr1.Text := '';
    end;
  end;
  cmdExportAll.Enabled := lstData.Count > 0;
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin

end;

procedure TFrmMain.cBackgroundColorChanged(Sender: TObject);
begin
  qr1.BackgroundColor := cBackground.ButtonColor;
end;

procedure TFrmMain.cForegroundColorChanged(Sender: TObject);
begin
  qr1.ForegroundColor := cForeground.ButtonColor;
end;

procedure TFrmMain.cmSaveClick(Sender: TObject);
begin
  SaveImageToFile;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  qr1.Text := '';
end;

procedure TFrmMain.lstDataClick(Sender: TObject);
var
  sItem: string;
begin
  if lstData.ItemIndex > -1 then
  begin
    sItem := lstData.Items[lstData.ItemIndex];
    qr1.Text := sItem;
    txtEdit.Text := sItem;
    cmdDelete.Enabled := True;
    mnuDelItem.Enabled := True;
    cmdexport.Enabled := True;
  end;
end;

procedure TFrmMain.lstDataSelectionChange(Sender: TObject; User: boolean);
begin
  cmdExportAll.Enabled := lstData.Count > 0;
end;

procedure TFrmMain.mnuDelItemClick(Sender: TObject);
begin
  cmdDeleteClick(Sender);
end;

procedure TFrmMain.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.mnuExportAllImgClick(Sender: TObject);
begin
  cmdExportAllClick(sender);
end;

procedure TFrmMain.mnuExportImageClick(Sender: TObject);
begin
  cmdExportClick(Sender);
end;

procedure TFrmMain.mnuLstPopup(Sender: TObject);
begin
  mnuDelItem.Enabled := cmdDelete.Enabled;
  mnuExportImage.Enabled := cmdExport.Enabled;
  mnuExportAllImg.Enabled := lstData.Count > 0;
end;

procedure TFrmMain.mnuNewListClick(Sender: TObject);
begin
  if lstData.Items.Count > 0 then
  begin
    if MessageDlg(Text, 'Are you sure you want to clear the list?',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      lstData.Clear;
      qr1.Text := '';
      cmdDelete.Enabled := False;
      cmdexport.Enabled := False;
      cmdExportAll.Enabled := False;
    end;
  end;
end;

procedure TFrmMain.mnuNewLstClick(Sender: TObject);
begin
  mnuNewListClick(Sender);
end;

procedure TFrmMain.mnuOpenClick(Sender: TObject);
var
  od: TOpenDialog;
begin
  od := TOpenDialog.Create(self);
  od.Title := 'Open';
  od.Filter := 'Text Files(*.txt)|*.txt|All Files(*.*)|*.*';
  if od.Execute then
  begin
    lstData.Items.LoadFromFile(od.FileName);
  end;
  cmdExportAll.Enabled := lstData.Count > 0;
  od.Destroy;
end;

procedure TFrmMain.mnuSaveClick(Sender: TObject);
var
  lzFile: string;
begin
  lzFile := GetSaveDlgName('Text Files(*.txt)|*.txt|All Files(*.*)|*.*', 'txt');

  if lzFile <> '' then
  begin
    lstData.Items.SaveToFile(lzFile);
  end;
end;

end.
