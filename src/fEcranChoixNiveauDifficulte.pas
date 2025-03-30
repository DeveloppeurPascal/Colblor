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
/// File last update : 2025-03-30T17:54:10.000+02:00
/// Signature : 327d36230ff26854eb778b35f2e32e77e0ba4683
/// ***************************************************************************
/// </summary>

unit fEcranChoixNiveauDifficulte;

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
  fAncetreCadreTraduit,
  FMX.Layouts,
  cBoutonMenu;

type
  TfrmEcranChoixNiveauDifficulte = class(T_AncetreCadreTraduit)
    ZoneBoutonsMenu: TVertScrollBox;
    btnNiveauFacile: TBoutonMenu;
    btnNiveauDifficile: TBoutonMenu;
    btnNiveauMoyen: TBoutonMenu;
    procedure FrameResize(Sender: TObject);
    procedure btnNiveauFacileClick(Sender: TObject);
    procedure btnNiveauMoyenClick(Sender: TObject);
    procedure btnNiveauDifficileClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  frmEcranChoixNiveauDifficulte: TfrmEcranChoixNiveauDifficulte;

implementation

{$R *.fmx}

uses
  uInfosPartieEnCours,
  uEcrans;

procedure TfrmEcranChoixNiveauDifficulte.btnNiveauDifficileClick
  (Sender: TObject);
begin
  PartieEnCours.NiveauDeDifficulte := TNiveauDifficulte.Difficile;
  AfficheEcran(TEcranDuJeu.Jeu);
end;

procedure TfrmEcranChoixNiveauDifficulte.btnNiveauFacileClick(Sender: TObject);
begin
  PartieEnCours.NiveauDeDifficulte := TNiveauDifficulte.facile;
  AfficheEcran(TEcranDuJeu.Jeu);
end;

procedure TfrmEcranChoixNiveauDifficulte.btnNiveauMoyenClick(Sender: TObject);
begin
  PartieEnCours.NiveauDeDifficulte := TNiveauDifficulte.moyen;
  AfficheEcran(TEcranDuJeu.Jeu);
end;

procedure TfrmEcranChoixNiveauDifficulte.FrameResize(Sender: TObject);
var
  I: integer;
  Hauteur: single;
  HauteurElement: single;
  c: tcontrol;
begin
  inherited;
  Hauteur := 0;
  for I := 0 to ZoneBoutonsMenu.Content.ChildrenCount - 1 do
    if (ZoneBoutonsMenu.Content.children[I] is tcontrol) then
    begin
      c := ZoneBoutonsMenu.Content.children[I] as tcontrol;
      if c.Visible then
      begin
        HauteurElement := c.position.y + c.height + c.margins.Bottom;
        if Hauteur < HauteurElement then
          Hauteur := HauteurElement;
      end;
    end;
  if height - 10 < Hauteur then
    Hauteur := height - 10;
  ZoneBoutonsMenu.height := Hauteur;
end;

end.
