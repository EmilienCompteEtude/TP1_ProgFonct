Q1.
Pour savoir si un client a disparut (DOWN) et avoir une liste de client correcte et empeche les faux utilisateurs PID

Q2.
Si on implemente pas, les PID mort restent dans la liste.
De plus, l'implémentation de handle_info/2 permet d'éviter le crash du systeme

Q3.
La différence est que handle_call est synchrone et handle_cast asynchrone.
Broadcast est un cast car il ne bloque pas et n'attend rien de ses correspondants.

Q4.
