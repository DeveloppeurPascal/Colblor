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
/// File last update : 2025-03-30T17:39:16.000+02:00
/// Signature : e21af096b4af242f7ca8d7d1364e3c4c4d29ab69
/// ***************************************************************************
/// </summary>

program Colblor;

uses
  System.StartUpCopy,
  FMX.Forms,
  uDMTraductions in '..\lib-externes\Colblor-Translator\src\uDMTraductions.pas' {dmTraductions: TDataModule},
  fAncetreFicheTraduite in '..\lib-externes\Colblor-Translator\src\fAncetreFicheTraduite.pas' {_AncetreFicheTraduite},
  fColblor in 'fColblor.pas' {frmColblor},
  fAncetreCadreTraduit in '..\lib-externes\Colblor-Translator\src\fAncetreCadreTraduit.pas' {_AncetreCadreTraduit: TFrame},
  fEcranAccueil in 'fEcranAccueil.pas' {frmEcranAccueil: TFrame},
  fEcranChoixNiveauDifficulte in 'fEcranChoixNiveauDifficulte.pas' {frmEcranChoixNiveauDifficulte: TFrame},
  fEcranJeu in 'fEcranJeu.pas' {frmEcranJeu: TFrame},
  cGrilleDeJeu in 'cGrilleDeJeu.pas' {GrilleDeJeu: TFrame},
  cBoutonMenu in 'cBoutonMenu.pas' {BoutonMenu: TFrame},
  uInfosPartieEnCours in 'uInfosPartieEnCours.pas',
  uEcrans in 'uEcrans.pas',
  fEcranChoixTournoiWanOuLan in 'fEcranChoixTournoiWanOuLan.pas' {frmEcranChoixTournoiWanOuLan: TFrame},
  uTournoiAPI in 'uTournoiAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmColblor, frmColblor);
  Application.Run;
end.
