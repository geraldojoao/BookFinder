import 'packagefluttermaterial.dart';
import 'dartconvert';
import 'packagehttphttp.dart' as http;
import 'packageproviderprovider.dart';
import 'packageshared_preferencesshared_preferences.dart';
import 'packageurl_launcherurl_launcher.dart' as url_launcher;

void main() = runApp(
  MultiProvider(
    providers [
      ChangeNotifierProvider(create (context) = AppState()),
      ChangeNotifierProvider(create (context) = FavoritesModel()),
    ],
    child BookFinderApp(),
  ),
);

class BookFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title 'BookFinder',
      theme Provider.ofAppState(context).isDarkMode
           ThemeData.dark().copyWith(
              primaryColor Colors.blueAccent,
              appBarTheme AppBarTheme(
                backgroundColor Colors.grey[850],
                titleTextStyle TextStyle(
                  color Colors.white,
                  fontSize 20,
                  fontWeight FontWeight.w600,
                ),
                iconTheme IconThemeData(color Colors.white),
              ),
              elevatedButtonTheme ElevatedButtonThemeData(
                style ElevatedButton.styleFrom(
                  backgroundColor Colors.blueAccent,
                  foregroundColor Colors.white,
                  textStyle TextStyle(fontWeight FontWeight.bold),
                  padding EdgeInsets.symmetric(vertical 12, horizontal 24),
                  shape RoundedRectangleBorder(
                    borderRadius BorderRadius.circular(8),
                  ),
                ),
              ),
              textTheme TextTheme(
                bodyMedium TextStyle(color Colors.white),
                titleMedium TextStyle(color Colors.white),
              ),
              cardColor Colors.grey[800],
              listTileTheme ListTileThemeData(textColor Colors.white),
            )
           ThemeData.light().copyWith(
              primaryColor Colors.blue,
              appBarTheme AppBarTheme(
                backgroundColor Colors.white,
                titleTextStyle TextStyle(
                  color Colors.black,
                  fontSize 20,
                  fontWeight FontWeight.w600,
                ),
                iconTheme IconThemeData(color Colors.black),
              ),
              elevatedButtonTheme ElevatedButtonThemeData(
                style ElevatedButton.styleFrom(
                  backgroundColor Colors.blue,
                  foregroundColor Colors.white,
                  textStyle TextStyle(fontWeight FontWeight.bold),
                  padding EdgeInsets.symmetric(vertical 12, horizontal 24),
                  shape RoundedRectangleBorder(
                    borderRadius BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
      home FutureBuilderbool(
        future Provider.ofAppState(context).isLoggedIn(),
        builder (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return FutureBuilderbool(
                future Provider.ofAppState(context).isFirstLaunch(),
                builder (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == true) {
                      return OnboardingScreen();
                    } else {
                      return BookSearchPage();
                    }
                  } else {
                    return LoadingIndicator();
                  }
                },
              );
            } else {
              return LoginPage();
            }
          } else {
            return LoadingIndicator();
          }
        },
      ),
      routes {
        'login' (context) = LoginPage(),
        'search' (context) = BookSearchPage(),
        'loading' (context) = LoadingScreen(),
        'results' (context) = BookResultsPage(),
        'details' (context) = BookDetailPage(),
        'profile' (context) = ProfilePage(),
        'settings' (context) = SettingsScreen(),
        'favorites' (context) = FavoritesScreen(),
        'about' (context) = AboutScreen(),
      },
    );
  }
}

class AppState extends ChangeNotifier {
  bool isLoggedInValue = false;
  bool isDarkMode = false;

  AppState() {
    _loadThemePreference();
    _loadLoginStatus();
  }

  Futurevoid _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode')  false;
    notifyListeners();
  }

  Futurevoid _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedInValue = prefs.getBool('isLoggedIn')  false;
    notifyListeners();
  }

  Futurevoid toggleTheme() async {
    isDarkMode = !isDarkMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Futurebool isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn')  false;
  }

  Futurevoid setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
    isLoggedInValue = value;
    notifyListeners();
  }

  Futurebool isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirst = prefs.getBool('first_launch')  true;
    if (isFirst) {
      await prefs.setBool('first_launch', false);
    }
    return isFirst;
  }

  void clearFavorites(BuildContext context) {
    Provider.ofFavoritesModel(context, listen false).clear();
    notifyListeners();
  }
}

class FavoritesModel extends ChangeNotifier {
  final ListMapdynamic, dynamic _items = [];

  ListMapdynamic, dynamic get items = _items;

  void add(Mapdynamic, dynamic book) {
    _items.add(book);
    notifyListeners();
  }

  void remove(Mapdynamic, dynamic book) {
    _items.remove(book);
    notifyListeners();
  }

  bool isFavorite(Mapdynamic, dynamic book) {
    return _items.contains(book);
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body Center(
        child Padding(
          padding const EdgeInsets.all(16.0),
          child Column(
            mainAxisAlignment MainAxisAlignment.center,
            children [
              Text(
                'BookFinder',
                style TextStyle(
                  fontSize 32,
                  fontWeight FontWeight.bold,
                  color Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height 32),
              ElevatedButton(
                onPressed () {
                  Provider.ofAppState(
                    context,
                    listen false,
                  ).setLoggedIn(true);
                  Navigator.pushReplacementNamed(context, 'search');
                },
                child Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() = _BookSearchPageState();
}

class _BookSearchPageState extends StateBookSearchPage {
  final _controller = TextEditingController();

  void _startSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      Navigator.pushNamed(context, 'loading', arguments query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar AppBar(
        title Text('Pesquisar Livros'),
        actions [
          IconButton(
            icon Icon(Icons.person),
            onPressed () {
              Navigator.pushNamed(context, 'profile');
            },
          ),
          IconButton(
            icon Icon(Icons.settings),
            onPressed () {
              Navigator.pushNamed(context, 'settings');
            },
          ),
        ],
      ),
      body Padding(
        padding const EdgeInsets.all(16),
        child Column(
          children [
            TextField(
              controller _controller,
              onSubmitted (_) = _startSearch(),
              decoration InputDecoration(
                labelText 'Digite o nome do livro...',
                border OutlineInputBorder(
                  borderRadius BorderRadius.circular(8),
                ),
                suffixIcon IconButton(
                  icon Icon(Icons.search),
                  onPressed _startSearch,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String query = ModalRoute.of(context)!.settings.arguments as String;

    Future.delayed(Duration(seconds 2), () async {
      final url =
          'httpswww.googleapis.combooksv1volumesq=${Uri.encodeQueryComponent(query)}';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final books = data['items']  [];

          Navigator.pushReplacementNamed(
            context,
            'results',
            arguments {'books' books, 'query' query},
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder (_) = ErrorScreen(
                message
                    'Erro ao buscar livros. Status code ${response.statusCode}',
              ),
            ),
          );
        }
      } catch (e) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder (_) = ErrorScreen(message 'Erro ao buscar livros $e'),
          ),
        );
      }
    });

    return Scaffold(
      body Center(
        child Column(
          mainAxisAlignment MainAxisAlignment.center,
          children [
            LoadingIndicator(),
            SizedBox(height 16),
            Text('Buscando livros...'),
          ],
        ),
      ),
    );
  }
}

class BookResultsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as MapString, dynamic;
    final books = args['books'];
    final query = args['query'];

    if (books.isEmpty) {
      return Scaffold(
        appBar AppBar(title Text('Resultados')),
        body Center(child Text('Nenhum resultado encontrado para $query.')),
      );
    }

    return Scaffold(
      appBar AppBar(
        title Text('Resultados para $query'),
        actions [
          IconButton(
            icon Icon(Icons.person),
            onPressed () {
              Navigator.pushNamed(context, 'profile');
            },
          ),
          IconButton(
            icon Icon(Icons.settings),
            onPressed () {
              Navigator.pushNamed(context, 'settings');
            },
          ),
        ],
      ),
      body ListView.builder(
        itemCount books.length,
        itemBuilder (_, index) {
          final volumeInfo = books[index]['volumeInfo'];
          final title = volumeInfo['title']  'Sem título';
          final authors = (volumeInfo['authors']  ['Desconhecido']).join(
            ', ',
          );
          final imageUrl = volumeInfo['imageLinks']['thumbnail'];

          return Card(
            elevation 3,
            margin EdgeInsets.symmetric(horizontal 16, vertical 8),
            shape RoundedRectangleBorder(
              borderRadius BorderRadius.circular(12),
            ),
            child ListTile(
              leading ClipRRect(
                borderRadius BorderRadius.circular(8),
                child imageUrl != null
                     Image.network(
                        imageUrl,
                        width 50,
                        height 50,
                        fit BoxFit.cover,
                        errorBuilder
                            (
                              BuildContext context,
                              Object exception,
                              StackTrace stackTrace,
                            ) {
                              return Icon(Icons.image_not_supported, size 50);
                            },
                      )
                     Icon(Icons.book, size 50),
              ),
              title Text(title, style TextStyle(fontWeight FontWeight.w500)),
              subtitle Text(authors),
              onTap () {
                Navigator.pushNamed(context, 'details', arguments volumeInfo);
              },
            ),
          );
        },
      ),
    );
  }
}

class BookDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final book = ModalRoute.of(context)!.settings.arguments as Map;
    final title = book['title']  'Sem título';
    final authors = (book['authors']  ['Desconhecido']).join(', ');
    final description = book['description']  'Sem descrição disponível.';
    final imageUrl = book['imageLinks']['thumbnail'];
    final favoritesModel = Provider.ofFavoritesModel(context, listen false);
    final isFavorite = favoritesModel.isFavorite(book);

    return Scaffold(
      appBar AppBar(
        title Text(title, overflow TextOverflow.ellipsis),
        actions [
          IconButton(
            icon Icon(
              isFavorite  Icons.favorite  Icons.favorite_border,
              color Colors.redAccent,
            ),
            onPressed () {
              if (isFavorite) {
                favoritesModel.remove(book);
              } else {
                favoritesModel.add(book);
              }
            },
          ),
          IconButton(
            icon Icon(Icons.person),
            onPressed () {
              Navigator.pushNamed(context, 'profile');
            },
          ),
          IconButton(
            icon Icon(Icons.settings),
            onPressed () {
              Navigator.pushNamed(context, 'settings');
            },
          ),
        ],
      ),
      body Padding(
        padding const EdgeInsets.all(16),
        child ListView(
          children [
            if (imageUrl != null)
              Center(
                child ClipRRect(
                  borderRadius BorderRadius.circular(12),
                  child Image.network(
                    imageUrl,
                    height 200,
                    fit BoxFit.cover,
                    errorBuilder
                        (
                          BuildContext context,
                          Object exception,
                          StackTrace stackTrace,
                        ) {
                          return Icon(Icons.image_not_supported, size 100);
                        },
                  ),
                ),
              )
            else
              Center(child Icon(Icons.book, size 100)),
            SizedBox(height 16),
            Text(
              title,
              style TextStyle(fontSize 22, fontWeight FontWeight.bold),
            ),
            SizedBox(height 8),
            Text(
              'Autor(es) $authors',
              style TextStyle(fontStyle FontStyle.italic),
            ),
            SizedBox(height 16),
            Text(description),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar AppBar(
        title Text('Perfil'),
        actions [
          IconButton(
            icon Icon(Icons.settings),
            onPressed () {
              Navigator.pushNamed(context, 'settings');
            },
          ),
        ],
      ),
      body ConsumerFavoritesModel(
        builder (context, favoritesModel, child) {
          return favoritesModel.items.isEmpty
               Center(child Text('Nenhum livro favoritado.'))
               ListView.builder(
                  itemCount favoritesModel.items.length,
                  itemBuilder (context, index) {
                    final book = favoritesModel.items[index];
                    final title = book['title']  'Sem título';
                    final authors = (book['authors']  ['Desconhecido']).join(
                      ', ',
                    );
                    final imageUrl = book['imageLinks']['thumbnail'];
                    return Card(
                      elevation 3,
                      margin EdgeInsets.symmetric(horizontal 16, vertical 8),
                      shape RoundedRectangleBorder(
                        borderRadius BorderRadius.circular(12),
                      ),
                      child ListTile(
                        leading ClipRRect(
                          borderRadius BorderRadius.circular(8),
                          child imageUrl != null
                               Image.network(
                                  imageUrl,
                                  width 50,
                                  height 50,
                                  fit BoxFit.cover,
                                  errorBuilder
                                      (
                                        BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace,
                                      ) {
                                        return Icon(
                                          Icons.image_not_supported,
                                          size 50,
                                        );
                                      },
                                )
                               Icon(Icons.book, size 50),
                        ),
                        title Text(title),
                        subtitle Text(authors),
                        onTap () {
                          Navigator.pushNamed(
                            context,
                            'details',
                            arguments book,
                          );
                        },
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar AppBar(title Text('Configurações')),
      body Padding(
        padding const EdgeInsets.all(16.0),
        child Column(
          children [
            Card(
              elevation 2,
              shape RoundedRectangleBorder(
                borderRadius BorderRadius.circular(12),
              ),
              child Padding(
                padding const EdgeInsets.symmetric(horizontal 16),
                child Row(
                  mainAxisAlignment MainAxisAlignment.spaceBetween,
                  children [
                    Text('Tema Escuro'),
                    ConsumerAppState(
                      builder (context, appState, child) = Switch(
                        value appState.isDarkMode,
                        onChanged (value) = appState.toggleTheme(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height 16),
            ElevatedButton(
              onPressed () {
                showDialog(
                  context context,
                  builder (BuildContext context) {
                    return AlertDialog(
                      shape RoundedRectangleBorder(
                        borderRadius BorderRadius.circular(12),
                      ),
                      title Text('Limpar Favoritos'),
                      content Text(
                        'Tem certeza que deseja limpar todos os livros favoritos',
                      ),
                      actions Widget[
                        TextButton(
                          child Text('Cancelar'),
                          onPressed () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          child Text('Limpar'),
                          onPressed () {
                            Provider.ofAppState(
                              context,
                              listen false,
                            ).clearFavorites(context);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child Text('Limpar Favoritos'),
            ),
            SizedBox(height 16),
            ElevatedButton(
              onPressed () {
                Navigator.pushNamed(context, 'about');
              },
              child Text('Sobre o App'),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar AppBar(title Text('Favoritos')),
      body ConsumerFavoritesModel(
        builder (context, favoritesModel, child) {
          return favoritesModel.items.isEmpty
               Center(child Text('Nenhum livro favoritado.'))
               ListView.builder(
                  itemCount favoritesModel.items.length,
                  itemBuilder (context, index) {
                    final book = favoritesModel.items[index];
                    final title = book['title']  'Sem título';
                    final authors = (book['authors']  ['Desconhecido']).join(
                      ', ',
                    );
                    final imageUrl = book['imageLinks']['thumbnail'];
                    return Card(
                      elevation 3,
                      margin EdgeInsets.symmetric(horizontal 16, vertical 8),
                      shape RoundedRectangleBorder(
                        borderRadius BorderRadius.circular(12),
                      ),
                      child Dismissible(
                        key Key(book.toString()),
                        onDismissed (direction) {
                          favoritesModel.remove(book);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content Text('$title removido dos favoritos'),
                            ),
                          );
                        },
                        background Container(
                          decoration BoxDecoration(
                            color Colors.redAccent,
                            borderRadius BorderRadius.circular(12),
                          ),
                          alignment Alignment.centerRight,
                          padding EdgeInsets.only(right 20.0),
                          child Icon(Icons.delete, color Colors.white),
                        ),
                        child ListTile(
                          leading ClipRRect(
                            borderRadius BorderRadius.circular(8),
                            child imageUrl != null
                                 Image.network(
                                    imageUrl,
                                    width 50,
                                    height 50,
                                    fit BoxFit.cover,
                                    errorBuilder
                                        (
                                          BuildContext context,
                                          Object exception,
                                          StackTrace stackTrace,
                                        ) {
                                          return Icon(
                                            Icons.image_not_supported,
                                            size 50,
                                          );
                                        },
                                  )
                                 Icon(Icons.book, size 50),
                          ),
                          title Text(title),
                          subtitle Text(authors),
                          onTap () {
                            Navigator.pushNamed(
                              context,
                              'details',
                              arguments book,
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar AppBar(title Text('Sobre o App')),
      body Padding(
        padding const EdgeInsets.all(16.0),
        child Column(
          crossAxisAlignment CrossAxisAlignment.start,
          children [
            Text(
              'BookFinder',
              style TextStyle(fontSize 24, fontWeight FontWeight.bold),
            ),
            SizedBox(height 8),
            Text('Versão 1.0.0'),
            SizedBox(height 16),
            Text('Desenvolvedor João Geraldo da S. Neto'),
            SizedBox(height 16),
            InkWell(
              child Text(
                'GitHub Repository',
                style TextStyle(color Colors.blueAccent),
              ),
              onTap () async {
                const url =
                    'httpsgithub.comgeraldojoaoBookFinder';  Replace with your repo URL
                if (await url_launcher.canLaunchUrl(Uri.parse(url))) {
                  await url_launcher.launchUrl(Uri.parse(url));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content Text('Não foi possível abrir o link')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() = _OnboardingScreenState();
}

class _OnboardingScreenState extends StateOnboardingScreen {
  final PageController _pageController = PageController(initialPage 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body Padding(
        padding const EdgeInsets.all(16.0),
        child Column(
          children [
            Expanded(
              child PageView(
                controller _pageController,
                onPageChanged (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children [
                  _buildPage(
                    title 'Bem-vindo ao BookFinder!',
                    description
                        'Encontre seus livros favoritos de forma rápida e fácil.',
                    image
                        'httpswww.gstatic.comflutter-onestack-prototypegenuiexample_1.jpg',
                  ),
                  _buildPage(
                    title 'Pesquise e Descubra',
                    description
                        'Use nossa poderosa ferramenta de pesquisa para encontrar qualquer livro que você imaginar.',
                    image
                        'httpswww.gstatic.comflutter-onestack-prototypegenuiexample_1.jpg',
                  ),
                  _buildPage(
                    title 'Salve seus Favoritos',
                    description
                        'Adicione livros à sua lista de favoritos e acesse-os quando quiser.',
                    image
                        'httpswww.gstatic.comflutter-onestack-prototypegenuiexample_1.jpg',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment MainAxisAlignment.center,
              children _buildPageIndicator(),
            ),
            SizedBox(height 24),
            ElevatedButton(
              onPressed () {
                Navigator.pushReplacementNamed(context, 'search');
              },
              child Text('Começar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String description,
    required String image,
  }) {
    return Column(
      mainAxisAlignment MainAxisAlignment.center,
      children [
        Text(
          title,
          style TextStyle(fontSize 24, fontWeight FontWeight.bold),
          textAlign TextAlign.center,
        ),
        SizedBox(height 16),
        ClipRRect(
          borderRadius BorderRadius.circular(12),
          child Image.network(image, height 200),
        ),
        SizedBox(height 16),
        Text(
          description,
          style TextStyle(fontSize 16),
          textAlign TextAlign.center,
        ),
      ],
    );
  }

  ListWidget _buildPageIndicator() {
    ListWidget list = [];
    for (int i = 0; i  3; i++) {
      list.add(i == _currentPage  _indicator(true)  _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration Duration(milliseconds 150),
      margin EdgeInsets.symmetric(horizontal 8.0),
      height 8.0,
      width isActive  24.0  16.0,
      decoration BoxDecoration(
        color isActive  Theme.of(context).primaryColor  Colors.grey,
        borderRadius BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String message;

  const ErrorScreen({Key key, required this.message})  super(key key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar AppBar(title Text('Erro')),
      body Center(
        child Padding(
          padding const EdgeInsets.all(16.0),
          child Text(
            message,
            style TextStyle(fontSize 18, color Colors.red),
            textAlign TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child CircularProgressIndicator(
        valueColor AlwaysStoppedAnimationColor(
          Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}