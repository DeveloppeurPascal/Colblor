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
/// File last update : 2025-03-30T17:54:58.000+02:00
/// Signature : 96e69992415fd4d7352683fb6b442ce6f4cde33e
/// ***************************************************************************
/// </summary>

unit uTournoiAPI;

interface

uses
  uInfosPartieEnCours,
  cGrilleDeJeu,
  System.JSON;

type
  TCasesSansUI = array [0 .. (CNbCol - 1), 0 .. (CNbLig - 1)
    ] of TCouleurDesCases;

  TInfosTournoi = record
    APIUrl: string;
    IDPartie: string;
    IDJoueur: string;
    Grille: TCasesSansUI;
    Couleur: TCouleurDesCases;
    TempsRestant: integer;
    TempsAvantPartieSuivante: integer;
    IDDuGagnantDeLaPartie: string;
    PseudoDuGagnantDeLaPartie: string;
    StatusDeLaPartie: integer;
    Horodatage: Int64;
  end;

  TTournoiAPIgetGrilleCallback = reference to procedure;
  TTournoiAPIgetEcranCallback = reference to procedure(IDPartie: string;
    ListeJoueurs: TJSONArray);

var
  InfosTournoi: TInfosTournoi;

  /// <summary>
  /// Retourne l'URL du serveur d'API en fonction du contexte
  /// </summary>
procedure TournoiAPIServeurURL(APIUrl: string);

/// <summary>
/// Initialisation d'une partie en réseau par la récupération de la grille du jeu en cours et du statut de la partie
/// </summary>
procedure TournoiAPIgetGrille(Pseudo: string;
  CallbackOK: TTournoiAPIgetGrilleCallback;
  CallbackError: TTournoiAPIgetGrilleCallback);

/// <summary>
/// Envoi de la grille en cours du joueur au serveur
/// </summary>
procedure TournoiAPIsendGrille(GrilleDuJoueur: TJSONArray;
  Callback: TTournoiAPIgetGrilleCallback);

/// <summary>
/// Récupération des grilles en cours par le programme Viewer
/// </summary>
procedure TournoiAPIgetEcrans(CallbackOK: TTournoiAPIgetEcranCallback;
  CallbackError: TTournoiAPIgetGrilleCallback);

implementation

uses
  System.classes,
  System.sysutils,
  System.Threading,
  System.net.httpclient,
  System.NetEncoding,
  System.net.mime;

procedure TournoiAPIServeurURL(APIUrl: string);
begin
  if APIUrl.EndsWith('/') then
    InfosTournoi.APIUrl := APIUrl.Substring(0, APIUrl.Length - 1)
  else
    InfosTournoi.APIUrl := APIUrl;
end;

procedure TournoiAPIgetGrille(Pseudo: string;
  CallbackOK: TTournoiAPIgetGrilleCallback;
  CallbackError: TTournoiAPIgetGrilleCallback);
begin
  if InfosTournoi.APIUrl.isempty then
    raise exception.create('Serveur non indiqué pour le tournoi.');
  ttask.run(
    procedure
    var
      serveur: thttpclient;
      reponse: ihttpresponse;
      jso: tjsonobject;
      jsaCol, jsaLig: TJSONArray;
      jsv1, jsv2: tjsonvalue;
      i, j: integer;
    begin
      try
        serveur := thttpclient.create;
        try
          reponse := serveur.get(InfosTournoi.APIUrl + '/getGrille.php?pseudo='
            + TURLEncoding.URL.Encode(PartieEnCours.NomDuJoueur));
          case reponse.StatusCode of
            200:
              begin
                jso := tjsonobject.ParseJSONValue
                  (reponse.ContentAsString(tencoding.UTF8)) as tjsonobject;
                if not assigned(jso) then
                  raise exception.create('TournoiAPI response error 02');
                try
                  InfosTournoi.IDPartie :=
                    (jso.GetValue('idpartie') as TJSONString).Value;
                  InfosTournoi.IDJoueur :=
                    (jso.GetValue('idjoueur') as TJSONString).Value;
                  InfosTournoi.Couleur :=
                    TCouleurDesCases((jso.GetValue('couleur')
                    as TJSONNumber).AsInt);
                  jsaLig := jso.GetValue('grille') as TJSONArray;
                  j := 0;
                  for jsv1 in jsaLig do
                  begin
                    jsaCol := jsv1 as TJSONArray;
                    i := 0;
                    for jsv2 in jsaCol do
                    begin
                      InfosTournoi.Grille[i, j] :=
                        TCouleurDesCases((jsv2 as TJSONNumber).AsInt);
                      inc(i);
                    end;
                    inc(j);
                  end;
                  InfosTournoi.TempsRestant :=
                    (jso.GetValue('delairestant') as TJSONNumber).AsInt;
                  InfosTournoi.TempsAvantPartieSuivante :=
                    (jso.GetValue('delaiavantsuivante') as TJSONNumber).AsInt;
                finally
                  jso.free;
                end;
                tthread.Synchronize(nil,
                  procedure
                  begin
                    CallbackOK;
                  end);
              end;
          else
            raise exception.create('TournoiAPI Error 01 : ' +
              reponse.StatusCode.ToString + ' - ' + reponse.StatusText);
          end;
        finally
          serveur.free;
        end;
      except
        tthread.forcequeue(nil,
          procedure
          begin
            CallbackError;
          end);
      end;
    end);
end;

procedure TournoiAPIsendGrille(GrilleDuJoueur: TJSONArray;
Callback: TTournoiAPIgetGrilleCallback);
begin
  if InfosTournoi.APIUrl.isempty then
    raise exception.create('Serveur non indiqué pour le tournoi.');
  ttask.run(
    procedure
    var
      serveur: thttpclient;
      reponse: ihttpresponse;
      jso: tjsonobject;
      POSTParams: tmultipartformdata;
    begin
      try
        serveur := thttpclient.create;
        try
          POSTParams := tmultipartformdata.create;
          try
            POSTParams.AddField('idpartie', InfosTournoi.IDPartie);
            POSTParams.AddField('idjoueur', InfosTournoi.IDJoueur);
            POSTParams.AddField('grille', GrilleDuJoueur.tojson);
            GrilleDuJoueur.free;
            reponse := serveur.post(InfosTournoi.APIUrl + '/sendGrille.php',
              POSTParams);
          finally
            POSTParams.free;
          end;
          (*
            * si le joueur reçoit un 404,
            => partie terminée, une nouvelle a commencé,
            (ce cas ne doit pas se produire sauf bug du jeu sur les timer)

            * si le jeu reçoit un 400,
            => on retourne au menu,
            => on quitte le mode de jeu en cours

            * si le jeu reçoit un 200

            ** si le statut est 0
            => on ne fait rien de plus

            ** si le statut est 1,
            => on affiche un écran disant que le joueur a gagné

            ** si le statut est 2,
            => on affiche un écran disant que le joueur a réussi sa grille mais que le jeu a été gagné par un autre

            ** si le statut est 3,
            => délai écoulé sur cette partie, le joueur a perdu
          *)
          case reponse.StatusCode of
            200:
              begin
                jso := tjsonobject.ParseJSONValue
                  (reponse.ContentAsString(tencoding.UTF8)) as tjsonobject;
                if not assigned(jso) then
                  raise exception.create('TournoiAPI response error 02');
                try
                  InfosTournoi.StatusDeLaPartie :=
                    (jso.GetValue('status') as TJSONNumber).AsInt;
                  InfosTournoi.PseudoDuGagnantDeLaPartie :=
                    (jso.GetValue('pseudo') as TJSONString).Value;
                finally
                  jso.free;
                end;
              end;
          else
            InfosTournoi.StatusDeLaPartie := -reponse.StatusCode;
            InfosTournoi.PseudoDuGagnantDeLaPartie := reponse.StatusText;
          end;
          tthread.Synchronize(nil,
            procedure
            begin
              Callback;
            end);
        finally
          serveur.free;
        end;
      except
        on e: exception do
        begin
          InfosTournoi.StatusDeLaPartie := low(integer);
          InfosTournoi.PseudoDuGagnantDeLaPartie := e.Message;
          tthread.Synchronize(nil,
            procedure
            begin
              Callback;
            end);
        end;
      end;
    end);
end;

procedure TournoiAPIgetEcrans(CallbackOK: TTournoiAPIgetEcranCallback;
CallbackError: TTournoiAPIgetGrilleCallback);
begin
  if InfosTournoi.APIUrl.isempty then
    raise exception.create('Serveur non indiqué pour le tournoi.');
  ttask.run(
    procedure
    var
      serveur: thttpclient;
      reponse: ihttpresponse;
      jso: tjsonobject;
      jsaEcrans: TJSONArray;
    begin
      try
        serveur := thttpclient.create;
        try
          reponse := serveur.get(InfosTournoi.APIUrl +
            '/getEcrans.php?horodatage=' + InfosTournoi.Horodatage.ToString);
          case reponse.StatusCode of
            200:
              begin
                jso := tjsonobject.ParseJSONValue
                  (reponse.ContentAsString(tencoding.UTF8)) as tjsonobject;
                if not assigned(jso) then
                  raise exception.create('TournoiAPI response error 02');
                try
                  InfosTournoi.IDPartie :=
                    (jso.GetValue('idpartie') as TJSONString).Value;
                  try
                    InfosTournoi.IDDuGagnantDeLaPartie :=
                      (jso.GetValue('GagnantIDJoueur') as TJSONString).Value;
                  except
                    InfosTournoi.IDDuGagnantDeLaPartie := '';
                  end;
                  try
                    InfosTournoi.PseudoDuGagnantDeLaPartie :=
                      (jso.GetValue('GagnantPseudo') as TJSONString).Value.trim;
                  except
                    InfosTournoi.PseudoDuGagnantDeLaPartie := '';
                  end;
                  try
                    InfosTournoi.Horodatage :=
                      (jso.GetValue('horodatage') as TJSONNumber).AsInt64;
                  except
                    InfosTournoi.Horodatage := 0;
                  end;
                  try
                    jsaEcrans := jso.GetValue('ecrans') as TJSONArray;
                  except
                    jsaEcrans := nil;
                  end;
                  if not assigned(jsaEcrans) then
                  begin
                    jsaEcrans := TJSONArray.create;
                    jso.AddPair('ecrans', jsaEcrans);
                  end;
                  tthread.Synchronize(nil,
                    procedure
                    begin
                      CallbackOK(InfosTournoi.IDPartie, jsaEcrans);
                    end);
                finally
                  jso.free;
                end;
              end;
          else
            raise exception.create('TournoiAPI Error 01 : ' +
              reponse.StatusCode.ToString + ' - ' + reponse.StatusText);
          end;
        finally
          serveur.free;
        end;
      except
        tthread.forcequeue(nil,
          procedure
          begin
            CallbackError;
          end);
      end;
    end);
end;

initialization

InfosTournoi.APIUrl := '';
InfosTournoi.Horodatage := 0;

end.
