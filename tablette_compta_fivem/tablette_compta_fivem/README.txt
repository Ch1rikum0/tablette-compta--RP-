TABLETTE DE COMPTABILITE FIVEM
==============================

INSTALLATION
1. Copie le dossier "tablette_compta_fivem" dans le dossier resources de ton serveur.
2. Ouvre config.lua et remplace Config.ExternalUrl par ton lien en https:// ou http://.
3. Dans server.cfg, ajoute :
   ensure tablette_compta_fivem

4. Par defaut, l'ouverture est disponible avec /compta.
5. Par defaut, seuls les joueurs ayant la permission ACE peuvent enregistrer des operations.
   Pour autoriser les administrateurs du groupe admin, ajoute dans server.cfg :
   add_ace group.admin tabletcompta.manage allow

   Si tu veux utiliser un autre groupe, configure les permissions ACE correspondantes.
   Pour des tests seulement, tu peux mettre Config.RequireAcePermission = false dans config.lua.
   Ne desactive pas cette protection sur un serveur public.

FONCTIONNEMENT
- Solde et historique sont partages par tous les joueurs.
- Les donnees sont conservees dans data.json.
- Les sorties sont refusees si le solde est insuffisant.
- L'historique conserve les dernieres operations selon Config.MaxTransactions.
- Le lien externe se configure dans config.lua.

IMPORTANT
- Cette ressource cree une comptabilite autonome : elle ne modifie pas le compte bancaire ESX/QBCore.
- Le lien externe doit etre une adresse HTTP ou HTTPS fiable.
- Sauvegarde data.json avant toute modification manuelle.
