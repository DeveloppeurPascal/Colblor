/// <summary>
/// ***************************************************************************
///
/// Colblor
///
/// Copyright 2021-2025 Patrick PREMARTIN under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://colblor.gamolf.fr
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Colblor
///
/// ***************************************************************************
/// File last update : 2025-03-30T17:53:58.000+02:00
/// Signature : 20b37e626ade8de74b10faeb536e5cb8c5db71e4
/// ***************************************************************************
/// </summary>

unit fColblor;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  fAncetreFicheTraduite,
  FMX.Layouts,
  fAncetreCadreTraduit,
  fEcranAccueil,
  FMX.Ani;

type
  TfrmColblor = class(T_AncetreFicheTraduite)
    animMasquageEcran: TFloatAnimation;
    animAffichageEcran: TFloatAnimation;
    procedure FormCreate(Sender: TObject);
    procedure animAffichageEcranFinish(Sender: TObject);
    procedure animMasquageEcranFinish(Sender: TObject);
  private
    { Déclarations privées }
  public
    procedure TraduireTextes; override;
    { Déclarations publiques }

  end;

var
  frmColblor: TfrmColblor;

implementation

{$R *.fmx}

uses
  uDMTraductions,
  uEcrans;

{ TfrmColblor }

procedure TfrmColblor.animAffichageEcranFinish(Sender: TObject);
begin
  animAffichageEcran.Enabled := false;
  (animAffichageEcran.Parent as T_AncetreCadreTraduit).Align :=
    TAlignLayout.Contents;
end;

procedure TfrmColblor.animMasquageEcranFinish(Sender: TObject);
begin
  animMasquageEcran.Enabled := false;
end;

procedure TfrmColblor.FormCreate(Sender: TObject);
begin
  inherited;
  tthread.forcequeue(nil,
    procedure
    begin
      AfficheEcran(TEcranDuJeu.Accueil);
    end);
end;

procedure TfrmColblor.TraduireTextes;
begin
  inherited;
  // TODO : à compléter plus tard pour les traductions des textes du jeu
  caption := _('TitreDuJeu', caption);
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
