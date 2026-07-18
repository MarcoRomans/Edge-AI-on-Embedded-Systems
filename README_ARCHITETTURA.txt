## Architettura hardware della board utilizzata

Per lo svolgimento degli esperimenti è stata utilizzata una board **BeagleBone AI-64**, scelta come piattaforma embedded per l'esecuzione locale dei modelli Qwen2.5. La board è stata configurata in modo da poter eseguire benchmark di inferenza, test sotto stress CPU e prove di comportamento real-time.

Dal punto di vista hardware, la BeagleBone AI-64 è stata alimentata tramite un alimentatore esterno da **5V**, collegato al connettore di alimentazione della board. Questa scelta è stata importante per garantire maggiore stabilità durante l'esecuzione dei modelli, soprattutto nei test più lunghi e nei casi in cui la CPU era sottoposta a carico elevato. L'alimentazione tramite USB non è stata considerata sufficiente per questo tipo di utilizzo, perché durante gli esperimenti la board doveva sostenere inferenza, accesso alla memoria esterna e carichi di stress.

Per il collegamento e il controllo della board è stato utilizzato anche un collegamento seriale tramite **UART**. A questo scopo sono stati necessari appositi adattatori per collegare correttamente i pin della BeagleBone al convertitore seriale. Il collegamento UART è stato utile soprattutto per verificare lo stato della board, controllare eventuali messaggi di boot e avere un canale di accesso più diretto in caso di problemi con la connessione di rete o con SSH. Nel collegamento seriale sono stati considerati i segnali principali, cioè **GND**, **TXD** e **RXD**, facendo attenzione alla corretta corrispondenza tra trasmissione e ricezione e ai livelli logici supportati.

Durante l'esecuzione degli esperimenti è stata utilizzata anche una **ventola di raffreddamento**. Questo elemento è stato aggiunto perché i test di inferenza e soprattutto gli esperimenti con `stress-ng` possono mantenere la CPU sotto carico per diversi minuti. La ventola ha quindi aiutato a mantenere più stabile la temperatura della board e a ridurre il rischio di throttling termico, che avrebbe potuto alterare le misure di latenza e throughput.

Un altro elemento importante della configurazione è stata la **memoria USB esterna**. I modelli Qwen2.5 in formato GGUF occupano molto spazio rispetto alla memoria interna della board, specialmente nel caso dei modelli 1.5B e 3B. Per questo motivo è stata collegata una memoria USB esterna, montata nel percorso:

/mnt/i1data

All'interno della memoria esterna è stata creata la cartella principale del progetto:

/mnt/i1data/i1-edge-ai-slm

In questa cartella sono stati organizzati modelli, script, prompt, risultati e log. L'utilizzo della memoria esterna ha permesso di evitare problemi di spazio sulla memoria interna della BeagleBone e ha reso più semplice il trasferimento e la gestione dei file sperimentali.

In sintesi, l'architettura hardware utilizzata comprendeva:

- board BeagleBone AI-64;
- alimentatore esterno da 5V;
- collegamento USB/rete per accesso SSH;
- collegamento seriale UART tramite adattatori dedicati;
- ventola di raffreddamento;
- memoria USB esterna per modelli e risultati.

Questa configurazione ha permesso di usare la BeagleBone AI-64 come piattaforma embedded autonoma per l'esecuzione locale dei modelli Qwen2.5 e per la raccolta dei risultati sperimentali.