# ratptest
Test technique relatifs à ma candidature pour la RATP.

Cette application permet d'afficher une liste de strings selon divers paramètres, ainsi que d'afficher les requêtes les plus courantes. Une bibliothèque a été utilisée, il s'agit de Hero. Elle permet d'animer facilement les transitions d'écran, sans avoir besoin de rajouter de code pour les transisions les plus simples.

Le pattern utilisé est MVC, le business layer est composé d'un objet StringGenerator ainsi qu'un objet Stats. Le projet utilise un storyboard comportant les écrans, ainsi que deux xib pour les cellules de liste.

L'application est darkmode ready, un comble pour une app en noir et blanc :D

J'ai ajouté un support sommaire d'accessibilité (VoiceOver). De même pour les tests d'intégration, ils ne valident pas réellement les features de l'app telles que le scroll ou l'édition des paramètres mais teste simplement que l'app affiche bien tous les écrans.

Au niveau test unitaires, StringGenerator, Stats et DataSource sont été testés. Les controllers ne sont pas testés unitairement, l'intégration s'en charge.

L'application permet d'outrepasser les limites d'initialisation de l'UITableView. En renvoyant Int.max dans la fonction numberOfRows de la tableView, l'os crash sur un overflow mémoire. Bien qu'il n'y ai aucun objet à afficher. Ma solution à ce problème, bien qu'inutile on est d'accord car personne n'ira scroller Int.max items, mais j'ai développé un objet DataSource permettant d'accroitre la limite progressivement en fonction du scroll. Vous pouvez donc tenter d'instancier l'écran de liste avec un chiffre énorme sans qu'il n'y ai de contrainte de mémoire ou de baisse de performance, bon courage pour le scroll. Très sincèrement, j'avais en tête d'ajouter une leaderboard via Firebase pour voir qui arriverait à scroll le plus loin si toutefois quelqu'un en avait le courage, mais je me suis vite calmé dans les démarches inutiles :D.

J'ai aussi développé Stats et DataSource à la manière PagesJaunes de chez Solocal, l'idée c'est de proposer une implémentation en définissant les variables, plutôt qu'une méthode plus classique où l'on proposerait un protocol suivit de classes ou structures l'implémentant. C'est à titre d'exemple seulement, personnellement je préfère la version plus classique orientée protocol.

En espérant vous avoir fait sourire et en vous souhaitant une bonne review.

