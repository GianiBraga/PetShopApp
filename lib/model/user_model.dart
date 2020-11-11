import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

//Utilizando o scoped Model para manter o estado do login no app
class UserModel extends Model {
  //Passando o FirebaseAuth.instance para _auth, pra não ter que digitar FirebaseAuth.instance  toda vez
  FirebaseAuth _auth = FirebaseAuth.instance;

  //Vai ser o usuario que estiver logado
  FirebaseUser firebaseUser;

  //Abrigar as informações do usuario.
  Map<String, dynamic> userData = Map();

  //Declarado o IsLoading, para quando o usuario estiver carregando ou processando algo.
  bool isLoading = false;

  //Deifindo um metodo statico para poder utilizar o Model em outras telas
  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  //Função para Criar um novo usuario
  Future<void> signUp(
      //Vai receber os dados do usuario, a senha, chamando as funções se teve sucesso ou não
      //Colocado o @required, assim quando é chamado em outra tela, já vai aparecer todos campos.
      {Map<String, dynamic> userData,
      String email,
      String pass,
      VoidCallback onSuccess,
      VoidCallback onFail}) {
    // passando true que está carregando
    isLoading = true;
    //Passando para o Flutter que teve modificações,
    notifyListeners();

    //Comando para a criação do novo usuario para o firebase
    _auth
        .createUserWithEmailAndPassword(
      email: userData["email"],
      password: pass,
    )
        .then((user) async {
      //salvando o user no firebase user.
      firebaseUser = user.user;

      //Chamando a função para salvar os dados do usuario no Firebase
      await _saveUserData(userData);

      //Teve sucesso, passa que não está mais carregando e notifica os listeners
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      // Não teve sucesso, passa que não está mais carregando e notifica os listeners
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  //Função para logar
  Future<void> signIn(
      {String email,
      String pass,
      VoidCallback onSuccess,
      VoidCallback onFail}) async {
    // passando true que está carregando
    isLoading = true;
    //Passando para o Flutter que teve modificações, será recriado as telas.
    notifyListeners();

    //Função do Firebase para logar.
    _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((user) async {
      firebaseUser = user.user;

      //Carregar informações do usuario quando ele logar.
      await _loadCurrentUser();

      //Se Logou com sucesso
      onSuccess();
      //Passando false, por que não está mais carregando
      isLoading = false;
      //Passando para o Flutter que teve modificações
      notifyListeners();
    }).catchError((e) {
      //Se teve erro
      onFail();
      //Passando false, por que não está mais carregando
      isLoading = false;
      //Passando para o Flutter que teve modificações
      notifyListeners();
    });
  }

  //Função para o usuario sair do aplicativo.
  Future<void> signOut() async {
    //Função para sair do firebase
    await _auth.signOut();

    //Passando um mapa vazio para o userdata e null pra FirebaseUser
    userData = Map();
    firebaseUser = null;

    //Passando para o Flutter que teve modificações
    notifyListeners();
  }

  //Função para recuperação da senha
  void recoverPass(String email) {
    //Comando do firebase para resetar a senha.
    _auth.sendPasswordResetEmail(email: email);
  }

  //Bool para identificar se tem um usuario logado ou não.
  bool isLoggedIn() {
    return firebaseUser != null;
  }

  //função para salvar os dados do usuario no Firebase
  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userData);
  }

  //Função para pegar o usuario atual no firebase
  Future<Null> _loadCurrentUser() async {
    //Verificar se o usuario é nulo, tentar buscar o usuario atual novamente
    if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      //Se for  diferente de nulo, logou, pega os dados do usuario no firebase.
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        //Carregando os dados do usuario, e notificando os listeners.
        userData = docUser.data;
        notifyListeners();
      }
    }
  }

  //Login com facebook
  void sigInFacebook() async {
    userData = Map();
    firebaseUser = null;

    final facebookLogin = FacebookLogin();

    final result = await facebookLogin.logIn(['email']);

    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    print(graphResponse.body);
    if (result.status == FacebookLoginStatus.loggedIn) {
      final credential = FacebookAuthProvider.getCredential(accessToken: token);
      _auth.signInWithCredential(credential);
    }
  }
}
