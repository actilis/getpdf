+============================================================+
| Service de génération de PDF ou d'images à partir d'une URL|
+============================================================+

Le but est de réduire les couches entre la soumission de l'URL
et le retour du contenu. Tout paramètre accepté par l'outil de
conversion utilisé doit pouvoir être soumis, par le biais d'un 
fichier de configuration.

Les images ou PDF générés sont conservés quelques temps sur le
serveur et purgés automatiquement.

Il est possible de récupérer directement le document (mode inline)
ou bien de suivre une redirection (mode redirect) pour pointer le
document sur le serveur.


Utilisation :
=============
http://pdf.actilis.net/?MODE=mode&COOKIE=name:value&CFG=name&URL=http[s]://url&FORMAT=png
                        ----      ------            ---      ===               ======
Exemples : 
==========
http://pdf.actilis.net/....
                       ?FORMAT=pdf&MODE=inline&URL=http://www.actilis.net
                       ?FORMAT=jpeg&MODE=inline&URL=http://www.actilis.net
                       ?FORMAT=png&MODE=redirect&URL=http://www.actilis.net


PARAMETRES : [OBL]=ogligatoire   / [OPT]=optionnel
============


[OBL] URL=....
 ===
   Parametre obligatoire. Doit commencer par "http"

   Peut (doit) être encodé par rawurlencode().
     ==> Sans encodage, ce paramètre doit nécessairement être le dernier.
     ==> En effet, ce paramètre peut contenir lui-même le séparateur "&" 
         notamment si l'URL appelée contient des paramètres.
         Ce caractère sert aussi de séparateur ici ==> problème.


[OBL] FORMAT : format de sortie
 ===
   pdf : PDF 1.4 (via wkhtmltopdf)
   png, jpeg, svg : Image (via wkhtmltoimage)


[OPT] MODE : mode de transmission du contenu
 ---
   redirect : renvoie vers le contenu généré par une redirection http
   inline : renvoie le contenu généré dans le document HTTP (en "inline")
   url : renvoie juste au format text/plain l'URL où est disponible le PDF généré


[OPT] COOKIE=name:value : permet de spécifier une session applicative
 ---
   Exemple : COOKIE=PHPSESSID:gliar1jog2kv953hdcp30nkj63

[OPT] CFG=name : Nom d'un fichier de configuration (man wkhtmltopdf) à utiliser
 ---
   Utilisation :  CFG=monfichier   => fichier   options/monfichier.conf  

   Configuration par défaut = "default"
   "default" pointe sur config/options/default.conf

   Son contenu est le suivant :

    # Options de base. Commentaires ignorés
    --quiet 
    --page-size A4 
    #--dpi 90 
    #--grayscale
    #--disable-javascript
    --javascript-delay 1000
    --header-spacing 5 
    --margin-left 5
    --margin-right 5
    --margin-top 5
    --margin-bottom 5
    --orientation Portrait
    --zoom 0.7


    Les fichiers de configuration doivent être livrés à l'avance.
    Ils peuvent contenir 
    - toute option acceptée par l'exécutable wkhtmltopdf / wkhtmltoimage, 
    - une par ligne pour plus de lisibilité,
    - des commentaires (#) ou lignes vides sont acceptés et ignorés.

    Ils sont stockés sur le serveur par sous un nom convenu avec l'utilisateur
    après avoir été validés.


En cas d'erreur : Un code retour HTTP est positionné

 400) MSG="Bad request"
        C'est un problème de paramètre d'appel.

 403) MSG="Accès interdit"
        C'est un problème de contrôle d'accès. L'adresse IP qui fait appel au 
        service n'y est pas autorisée (voir acl.conf)

 500) MSG="Probleme configuration serveur"
        Il ne doit pas se produire de problème de ce type sauf si un dossier 
        (logs, documents générés) n'est pas accessible au serveur.
        Vérifier la configuration (main.conf) et l'existence des dossiers, 
        puis leurs permissions.

 503) MSG="Probleme de code retour à la conversion"
        L'outil de conversion n'a pas pu aboutir, surement à cause d'une 
        erreur HTTP liée à un problème re requête ou une interdiction par le 
        serveur distant.
        La raison est annoncée sur la ligne "Exit with code 1 ..."
        ==> Host Not Found, 
            Autentication Required, 
            Content Operation Not Permitted Error...

 504) Gateway Timeout
        N'est pas renvoyé par le service, mais par le serveur HTTP si le
        contenu est trop long à convertir. Augmenter la valeur du paramètre
        Timeout d'Apache. (à 120 secondes, par exemple, cela suffit en
        théorie dans la plupart des cas)
        

   Le problème est en principe mentionné en détail dans la réponse.
   En testant avec wget, penser à l'option "--content-on-error"



Version : 20151216

