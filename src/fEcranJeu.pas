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
/// File last update : 2025-03-30T17:54:28.000+02:00
/// Signature : 2883566f83cd6303af4bb2c808a19df0ffed9a6f
/// ***************************************************************************
/// </summary>

unit fEcranJeu;

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
  uEcrans,
  cGrilleDeJeu,
  FMX.Objects,
  FMX.Layouts,
  FMX.Effects,
  uInfosPartieEnCours;

type
  TfrmEcranJeu = class(T_AncetreCadreTraduit, IJeu)
    GrilleDeJeu1: TGrilleDeJeu;
    GridPanelLayout1: TGridPanelLayout;
    txtCompteur: TText;
    txtChrono: TText;
    timerChrono: TTimer;
    Layout1: TLayout;
    ZoneBoutonsCouleur: TLayout;
    btnRouge: TRectangle;
    btnRougeEffect: TBevelEffect;
    btnBlack: TRectangle;
    btnBlackEffect: TBevelEffect;
    btnBlanc: TRectangle;
    btnBlancEffect: TBevelEffect;
    btnViolet: TRectangle;
    btnVioletEffect: TBevelEffect;
    btnJaune: TRectangle;
    btnJauneEffect: TBevelEffect;
    btnBleu: TRectangle;
    btnBleuEffect: TBevelEffect;
    btnVert: TRectangle;
    btnVertEffect: TBevelEffect;
    BlocageEcranBackground: TRectangle;
    BlocageEcran: TLayout;
    BlocageEcranAnimation: TAniIndicator;
    BlocageAttentePartie: TText;
    timerTournoiAttentePartie: TTimer;
    procedure timerChronoTimer(Sender: TObject);
    procedure btnBlackClick(Sender: TObject);
    procedure btnBlancClick(Sender: TObject);
    procedure btnBleuClick(Sender: TObject);
    procedure btnJauneClick(Sender: TObject);
    procedure btnRougeClick(Sender: TObject);
    procedure btnVertClick(Sender: TObject);
    procedure btnVioletClick(Sender: TObject);
    procedure timerTournoiAttentePartieTimer(Sender: TObject);
  private
    FCompteur: integer;
    FNbSecondes: integer;
    procedure SetCompteur(const Value: integer);
    procedure SetNbSecondes(const Value: integer);
    { Déclarations privées }
    procedure ClickSurCouleur(Couleur: TCouleurDesCases; Bouton: TRectangle;
      Effet: TBevelEffect);
    procedure ActiverBoutonCouleur(Bouton: TRectangle);
    function getBoutonCouleur(Couleur: TCouleurDesCases): TRectangle;
    procedure BloquerInterfaceUtilisateur(Activer: boolean;
      AttentePartieSuivante: boolean = false);
    procedure FinDePartie(msg: string = '');
  public
    { Déclarations publiques }
    property NbSecondes: integer read FNbSecondes write SetNbSecondes;
    property Compteur: integer read FCompteur write SetCompteur;
    procedure InitialiserLeJeu;
  end;

var
  frmEcranJeu: TfrmEcranJeu;

implementation

{$R *.fmx}

uses
  System.Threading,
  uTournoiAPI,
  uDMTraductions,
  FMX.DialogService,
  System.StrUtils,
  System.JSON;

{ TfrmEcranJeuTrainig }

procedure TfrmEcranJeu.ActiverBoutonCouleur(Bouton: TRectangle);
var
  o: tfmxobject;
  btn: TRectangle;
begin
  if (ZoneBoutonsCouleur.ChildrenCount > 0) then
    for o in ZoneBoutonsCouleur.Children do
      if (o is TRectangle) then
      begin
        btn := (o as TRectangle);
        if (btn = Bouton) then
        begin
          btn.Stroke.Kind := TBrushKind.solid;
          btn.Stroke.Color := talphacolors.orange;
          btn.Stroke.Thickness := 3;
        end
        else
          btn.Stroke.Kind := TBrushKind.none;
      end;
end;

procedure TfrmEcranJeu.BloquerInterfaceUtilisateur(Activer: boolean;
  AttentePartieSuivante: boolean);
begin
  if Activer then
  begin
    BlocageEcran.Visible := true;
    BlocageEcran.BringToFront;
    BlocageEcranAnimation.Visible := not AttentePartieSuivante;
    BlocageEcranAnimation.Enabled := BlocageEcranAnimation.Visible;
    BlocageAttentePartie.Visible := AttentePartieSuivante;
    if AttentePartieSuivante then
    begin
      BlocageAttentePartie.BringToFront;
      BlocageAttentePartie.text := '';
      BlocageAttentePartie.Visible := true;
      timerTournoiAttentePartie.Interval := 1000;
      timerTournoiAttentePartie.Tag := InfosTournoi.TempsAvantPartieSuivante;
      timerTournoiAttentePartie.Enabled := true;
    end;
  end
  else
  begin
    BlocageEcranAnimation.Enabled := false;
    BlocageEcran.Visible := false;
    BlocageAttentePartie.Visible := false;
    timerTournoiAttentePartie.Enabled := false;
  end;
end;

procedure TfrmEcranJeu.btnBlackClick(Sender: TObject);
begin
  ClickSurCouleur(TCouleurDesCases.noir, btnBlack, btnBlackEffect);
end;

procedure TfrmEcranJeu.btnBlancClick(Sender: TObject);
begin
  ClickSurCouleur(TCouleurDesCases.blanc, btnBlanc, btnBlancEffect);
end;

procedure TfrmEcranJeu.btnBleuClick(Sender: TObject);
begin
  ClickSurCouleur(TCouleurDesCases.bleu, btnBleu, btnBleuEffect);
end;

procedure TfrmEcranJeu.btnJauneClick(Sender: TObject);
begin
  ClickSurCouleur(TCouleurDesCases.jaune, btnJaune, btnJauneEffect);
end;

procedure TfrmEcranJeu.btnRougeClick(Sender: TObject);
begin
  ClickSurCouleur(TCouleurDesCases.rouge, btnRouge, btnRougeEffect);
end;

procedure TfrmEcranJeu.btnVertClick(Sender: TObject);
begin
  ClickSurCouleur(TCouleurDesCases.vert, btnVert, btnVertEffect);
end;

procedure TfrmEcranJeu.btnVioletClick(Sender: TObject);
begin
  ClickSurCouleur(TCouleurDesCases.violet, btnViolet, btnVioletEffect);
end;

procedure TfrmEcranJeu.ClickSurCouleur(Couleur: TCouleurDesCases;
  Bouton: TRectangle; Effet: TBevelEffect);
var
  Grille, Ligne: TJSONArray;
  i, j: integer;
begin

  // TODO : jouer un son de clic

  // Animation appuit sur bouton de couleur
  Effet.Enabled := false;
  ttask.run(
    procedure
    begin
      sleep(500);
      tthread.queue(nil,
        procedure
        begin
          Effet.Enabled := true;
        end);
    end);

  if (PartieEnCours.CouleurActuelle = Couleur) then
    exit;

  // changement de la couleur sur la grille
  GrilleDeJeu1.Bascule(PartieEnCours.CouleurActuelle, Couleur);
  PartieEnCours.CouleurActuelle := Couleur;
  ActiverBoutonCouleur(Bouton);

  Compteur := Compteur + 1;

  if PartieEnCours.ModeDeJeu = TModeDeJeu.Tournoi then
  begin
    if not GrilleDeJeu1.hasPlusieursCouleurs then
      ZoneBoutonsCouleur.Enabled := false;
    Grille := TJSONArray.create;
    try
      for j := 0 to CNbLig - 1 do
      begin
        Ligne := TJSONArray.create;
        for i := 0 to CNbCol - 1 do
          Ligne.add(ord(GrilleDeJeu1.Grille[i, j].Couleur));
        Grille.add(Ligne);
      end;
      TournoiAPIsendGrille(Grille,
        procedure
        begin
          case (InfosTournoi.StatusDeLaPartie) of
            0:
              ; // ok
            1: // partie gagnée par le joueur
              FinDePartie('Bravo, vous avez gagné cette manche !');
            // TODO : à traduire
            2: // partie gagnée par un autre joueur
              FinDePartie('La partie a été remportée par un autre joueur.' +
                ifthen((not InfosTournoi.PseudoDuGagnantDeLaPartie.IsEmpty),
                linefeed + 'Félicitez ' + InfosTournoi.PseudoDuGagnantDeLaPartie
                + ' pour sa victoire !', ''));
            // TODO : à traduire
            // TODO : ne pas afficher le pseudo du gagnant en tournoi WAN, le faire qu'en LAN
            3: // partie terminée
              FinDePartie('Délai dépassé. Partie terminée.');
            // TODO : à traduire
          else
            // code non géré, donc probablement une erreur de réseau,
            // de paramètre mal renseigné ou de données incohérentes
            FinDePartie('Fin de partie par KO technique.'); // TODO : à traduire
          end;
        end);
    except
      Grille.free;
    end;
  end
  else if not GrilleDeJeu1.hasPlusieursCouleurs then
    FinDePartie;
end;

procedure TfrmEcranJeu.FinDePartie(msg: string);
begin
  timerChrono.Enabled := false;
  PartieEnCours.PartieDemarree := false;
  PartieEnCours.PartieInitialisee := false;
  if PartieEnCours.ModeDeJeu = TModeDeJeu.Training then
  begin
    // TODO : calcul du score
    // TODO : afficher écran dédié à l'enregistrement du score
    // TODO : proposer de rejouer sans passer par le menu
    // ShowMessage('Bravo. Votre score est de ' + PartieEnCours.Score.ToString);
    var
    ch := 'Bravo. Vous avez fini en ' + Compteur.tostring + ' coup';
    // TODO : traduire
    if (Compteur > 1) then
      ch := ch + 's';
    if msg.IsEmpty then
      msg := ch;
  end;
  if (not msg.IsEmpty) then
    ShowMessage(msg);
  AfficheEcran(TEcranDuJeu.Accueil);
end;

function TfrmEcranJeu.getBoutonCouleur(Couleur: TCouleurDesCases): TRectangle;
begin
  case Couleur of
    TCouleurDesCases.rouge:
      result := btnRouge;
    TCouleurDesCases.vert:
      result := btnVert;
    TCouleurDesCases.jaune:
      result := btnJaune;
    TCouleurDesCases.bleu:
      result := btnBleu;
    TCouleurDesCases.blanc:
      result := btnBlanc;
    TCouleurDesCases.noir:
      result := btnBlack;
    TCouleurDesCases.violet:
      result := btnViolet;
  else
    raise exception.create('Couleur non gérée.'); // TODO : traduire
  end;
end;

procedure TfrmEcranJeu.InitialiserLeJeu;
begin
  txtChrono.text := '';
  txtCompteur.text := '';
  ZoneBoutonsCouleur.Enabled := false;
  GrilleDeJeu1.InitialiserLaGrille;
  if (PartieEnCours.ModeDeJeu = TModeDeJeu.Tournoi) then
  begin
    BloquerInterfaceUtilisateur(true);
    try
      TDialogService.InputQuery(_('', 'Saisie du pseudo'),
        [_('', 'Votre pseudo ?')], [PartieEnCours.NomDuJoueur],
        procedure(const AResult: TModalResult; const AValues: array of string)
        begin
          if ((AResult = mrok) and (length(AValues) = 1)) then
            PartieEnCours.NomDuJoueur := AValues[0].Trim;
          TournoiAPIgetGrille(PartieEnCours.NomDuJoueur,
            procedure // CallbackOK
            begin
              if (InfosTournoi.TempsRestant < 5) then
                BloquerInterfaceUtilisateur(true, true)
              else
              begin
                BloquerInterfaceUtilisateur(false);
                GrilleDeJeu1.RemplirLaGrilleDepuisGrilleTournoi;
                GrilleDeJeu1.AfficherLaGrille;
                ZoneBoutonsCouleur.Enabled := true;
                PartieEnCours.CouleurActuelle := InfosTournoi.Couleur;
                ActiverBoutonCouleur(getBoutonCouleur
                  (PartieEnCours.CouleurActuelle));
                PartieEnCours.PartieDemarree := true;
                Compteur := 0;
                NbSecondes := InfosTournoi.TempsRestant;
                timerChrono.Enabled := true;
              end;
            end,
            procedure // CallbackError
            begin
              ShowMessage('Serveur error');
              AfficheEcran(TEcranDuJeu.Accueil);
            end);
        end);
    except
      BloquerInterfaceUtilisateur(false);
    end;
  end
  else
  begin
    BloquerInterfaceUtilisateur(false);
    GrilleDeJeu1.RemplirLaGrille;
    GrilleDeJeu1.AfficherLaGrille;
    ZoneBoutonsCouleur.Enabled := true;

    if (PartieEnCours.ModeDeJeu = TModeDeJeu.Training) then
      case PartieEnCours.NiveauDeDifficulte of
        TNiveauDifficulte.facile:
          PartieEnCours.CouleurActuelle := GrilleDeJeu1.CouleurLaPlusUtilisee;
        TNiveauDifficulte.Moyen:
          PartieEnCours.CouleurActuelle := GrilleDeJeu1.CouleurAuHasard;
        TNiveauDifficulte.Difficile:
          PartieEnCours.CouleurActuelle := GrilleDeJeu1.CouleurLaMoinsUtilisee;
      else
        raise exception.create('Niveau de jeu non géré.');
      end
    else
      raise exception.create('Mode de jeu non géré');

    ActiverBoutonCouleur(getBoutonCouleur(PartieEnCours.CouleurActuelle));

    PartieEnCours.PartieDemarree := true;
    Compteur := 0;
    NbSecondes := 0;
    timerChrono.Enabled := true;
  end;
end;

procedure TfrmEcranJeu.SetCompteur(const Value: integer);
begin
  FCompteur := Value;
  txtCompteur.text := FCompteur.tostring;
end;

procedure TfrmEcranJeu.SetNbSecondes(const Value: integer);
begin
  FNbSecondes := Value;
  txtChrono.text := FNbSecondes.tostring;
  // TODO : formater l'affichage des secondes
end;

procedure TfrmEcranJeu.timerChronoTimer(Sender: TObject);
begin
  if PartieEnCours.ModeDeJeu = TModeDeJeu.Tournoi then
  begin
    NbSecondes := NbSecondes - 1;
    if (NbSecondes < 1) then
    begin
      timerChrono.Enabled := false;
      ShowMessage('Fin du temps réglementaire.' + linefeed +
        'Partie terminée.');
      FinDePartie;
    end;
  end
  else
    NbSecondes := NbSecondes + 1;
end;

procedure TfrmEcranJeu.timerTournoiAttentePartieTimer(Sender: TObject);
begin
  if (timerTournoiAttentePartie.Tag > 0) then
  begin
    timerTournoiAttentePartie.Tag := timerTournoiAttentePartie.Tag - 1;
    BlocageAttentePartie.autosize := false;
    case timerTournoiAttentePartie.Tag of
      0:
        BlocageAttentePartie.text := _('', 'C''est parti !');
      // TODO : à traduire
      1:
        BlocageAttentePartie.text :=
          _('', 'Tic tac' + linefeed + '1 seconde à attendre.');
      // TODO : à traduire
      2:
        BlocageAttentePartie.text :=
          _('', 'Tic tac' + linefeed + 'Tic tac' + linefeed +
          '2 secondes à attendre.');
      // TODO : à traduire
      3:
        BlocageAttentePartie.text :=
          _('', 'Tic tac' + linefeed + 'Tic tac' + linefeed + 'Tic tac' +
          linefeed + '3 secondes à attendre.');
      // TODO : à traduire
      4:
        BlocageAttentePartie.text :=
          _('', 'Concentrez vous...' + linefeed + '4 secondes!');
      // TODO : à traduire
    else
      BlocageAttentePartie.text :=
        _('', 'Partie terminée.' + linefeed + 'Prochaine partie dans ' +
        timerTournoiAttentePartie.Tag.tostring + ' secondes.');
      // TODO : à traduire
    end;
    BlocageAttentePartie.autosize := true;
  end
  else if timerTournoiAttentePartie.Enabled then
  begin
    timerTournoiAttentePartie.Enabled := false;
    InitialiserLeJeu;
  end;
end;

end.
