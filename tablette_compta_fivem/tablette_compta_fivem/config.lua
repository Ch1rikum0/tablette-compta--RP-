Config = {}

-- Commande d'ouverture de la tablette
Config.OpenCommand = 'compta'

-- Lien ouvert par le bouton "Ouvrir le lien externe".
-- Remplace cette URL par ton site de comptabilite.
Config.ExternalUrl = 'https://example.com'

-- Solde initial utilisé uniquement lors de la toute premiere creation des donnees.
Config.InitialBalance = 0

-- Nombre maximal d'operations conservees dans l'historique.
Config.MaxTransactions = 200

-- Protection des operations d'entree/sortie :
-- true = seuls les joueurs autorises par ACE peuvent modifier la comptabilite.
Config.RequireAcePermission = true
Config.AcePermission = 'tabletcompta.manage'

-- Autoriser tous les joueurs a ouvrir/consulter la tablette.
Config.AllowEveryoneToOpen = true
