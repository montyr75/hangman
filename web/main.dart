import 'dart:html';

import 'package:hangman/src/hangman.dart';

const List<String> wordList = const ["PLENTY","ACHIEVE","CLASS","STARE","AFFECT","THICK","CARRIER","BILL","SAY","ARGUE","OFTEN","GROW","VOTING","SHUT","PUSH","FANTASY","PLAN","LAST","ATTACK","COIN","ONE","STEM","SCAN","ENHANCE","PILL","OPPOSED","FLAG","RACE","SPEED","BIAS","HERSELF","DOUGH","RELEASE","SUBJECT","BRICK","SURVIVE","LEADING","STAKE","NERVE","INTENSE","SUSPECT","WHEN","LIE","PLUNGE","HOLD","TONGUE","ROLLING","STAY","RESPECT","SAFELY"];

const List<String> imageList = const [
  "https://i.imgur.com/kReMv94.png",
  "https://i.imgur.com/UFP8RM4.png",
  "https://i.imgur.com/9McnEXg.png",
  "https://i.imgur.com/vNAW0pa.png",
  "https://i.imgur.com/8UFWc9q.png",
  "https://i.imgur.com/rHCgIvU.png",
  "https://i.imgur.com/CtvIEMS.png",
  "https://i.imgur.com/Z2mPdX0.png"
];

const String winImage = "https://i.imgur.com/QYKuNwB.png";

HangmanGame game = new HangmanGame(wordList);

void main() {
  // set up event listeners
  game.onChange.listen(updateWordDisplay);
  game.onWrong.listen(updateGallowsImage);
  game.onWin.listen(win);
  game.onLose.listen(gameOver);
  newGameRef.onClick.listen(newGame);

  // put the letter buttons on the screen
  createLetterButtons();

  // start the first game
  newGame();
}

void newGame([_]) {
  // set up the game model
  game.newGame();

  // reset the letter buttons
  enableLetterButtons();

  // hide the New Game button
  newGameRef.hidden = true;

  // show the first gallows image
  updateGallowsImage(0);
}

void updateWordDisplay(String word) {
  wordRef.text = word;
}

void updateGallowsImage(int wrongGuesses) {
  gallowsRef.src = imageList[wrongGuesses];
}

void win([_]) {
  gallowsRef.src = winImage;
  gameOver();
}

void gameOver([_]) {
  enableLetterButtons(false);
  newGameRef.hidden = false;
}

void createLetterButtons() {
  // add letter buttons to the DOM
  generateAlphabet().forEach((String letter) {
    lettersRef.append(new ButtonElement()
      ..classes.add("letter-btn")
      ..text = letter
      ..onClick.listen((MouseEvent event) {
        (event.target as ButtonElement).disabled = true;
        game.guessLetter(letter);
      })
    );
  });
}

void enableLetterButtons([bool enable = true]) {
  // enable/disable all letter buttons
  lettersRef.children.forEach((Element btn) => (btn as ButtonElement).disabled = !enable);
}

List<String> generateAlphabet() {
  // get the character code for a capital 'A'
  int startingCharCode = 'A'.codeUnits.first;

  // create a list of 26 character codes (from 'A' to 'Z')
  List<int> charCodes = new List<int>.generate(26, (int index) => startingCharCode + index);

  // map character codes into a list of actual strings
  return charCodes.map((int code) => new String.fromCharCode(code)).toList();
}

ImageElement get gallowsRef => querySelector("#gallows");
DivElement get wordRef => querySelector("#word");
DivElement get lettersRef => querySelector("#letters");
ButtonElement get newGameRef => querySelector("#new-game");