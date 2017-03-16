# Fonctions de logging et d'erreur
function log_write {
  echo "$(date +%H:%M:%S)" "$@"  >> $LOG_FILE
}

function err_write {
  echo "$(date +%H:%M:%S)" "$@"  >> $ERR_FILE
}

# erreur_exit : 
#   Param1 = code retour, 
#   Param2 = libellé ou "ErrFile:nom_du_fichier_contenant_le_détail"
function erreur_exit {
  ERR=$1

  case "$ERR" in 
    400) MSG="Bad request" 
         DISPLAY_USAGE=${DISPLAY_USAGE_ON_ERROR:-false}
         ;;
    403) MSG="Accès interdit" 
         ;;
    500) MSG="Probleme configuration serveur"
         ;;
    503) MSG="Probleme de code retour à la conversion"
         ;;
    *)   ERR=999 ; MSG="Probleme dans le code (appel a erreur_exit avec code non géré)"
         ;;
  esac

  shift
  LIBELLE="$1"

  # Composition de la page d'erreur
  echo "Status: $ERR $MSG"
  echo "Content-Type: text/plain" 
  echo ""

  if [ ${LIBELLE:0:8} == "ErrFile:" ]; then
    echo "Erreur"
    cat  "${LIBELLE:8}"
  else
    echo "Erreur : $@"
    if [ "$DISPLAY_USAGE" == "true" ] ; then
      echo -e "\n\n\n"
      cat readme.txt
    fi
  fi

  exit 1
}

