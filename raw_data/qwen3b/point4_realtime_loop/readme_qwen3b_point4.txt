Qwen2.5-3B - Punto 4 Real-Time Loop
In questa cartella è riportato il tentativo di esecuzione del modello Qwen2.5-3B nel real-time loop.

Il modello non è stato incluso nel confronto quantitativo del punto 4 perché non ha prodotto inferenze valide sulla BeagleBone AI-64. Anche riducendo i parametri di esecuzione, il runtime ha restituito un errore di allocazione della memoria:

text failed to fit params to free device memory: was unable to fit model into system memory by reducing context, abort

Di conseguenza, il file CSV generato non rappresenta un risultato sperimentale valido di inferenza real-time, ma documenta un caso di non fattibilità.

Il motivo principale è che Qwen2.5-3B richiede troppe risorse rispetto alla memoria e alla capacità di calcolo disponibili sulla BeagleBone AI-64 per un’esecuzione ripetuta in real-time loop.

Per questo motivo, l’analisi quantitativa del punto 4 è stata limitata ai modelli che hanno prodotto inferenze valide, cioè:

Qwen2.5-0.5B
Qwen2.5-1.5B
Qwen2.5-3B viene quindi riportato solo come caso di limite hardware della piattaforma embedded.