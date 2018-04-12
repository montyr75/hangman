import 'dart:async';

class HangmanGame {
  static const int hanged = 7;			// number of wrong guesses before the player's demise

  final List<String> wordList;			// list of possible words to guess

  List<String> wordToGuess;
  final Set<String> lettersGuessed = new Set<String>();
  int wrongGuesses;

  StreamController _onWin = new StreamController.broadcast();
  Stream get onWin => _onWin.stream;

  StreamController _onLose = new StreamController.broadcast();
  Stream get onLose => _onLose.stream;

  StreamController<int> _onWrong = new StreamController<int>.broadcast();
  Stream<int> get onWrong => _onWrong.stream;

  StreamController<String> _onRight = new StreamController<String>.broadcast();
  Stream<String> get onRight => _onRight.stream;

  StreamController<String> _onChange = new StreamController<String>.broadcast();
  Stream<String> get onChange => _onChange.stream;

  HangmanGame(List<String> words) : wordList = new List<String>.from(words);

  void newGame() {
    // shuffle the word list
    wordList.shuffle();

    // grab the first word from the shuffled list and break it into a list of letters
    wordToGuess = wordList.first.split('');

    // reset wrong guess count
    wrongGuesses = 0;

    // clear the list of guessed letters
    lettersGuessed.clear();

    // declare the change (new word)
    _onChange.add(wordForDisplay);
  }

  void guessLetter(String letter) {
    // store guessed letter
    lettersGuessed.add(letter);

    if (wordToGuess.contains(letter)) {
      _onRight.add(letter);

      if (isWordComplete) {
        _onChange.add(fullWord);
        _onWin.add(null);
      }
      else {
        _onChange.add(wordForDisplay);
      }
    }
    else {
      wrongGuesses++;

      _onWrong.add(wrongGuesses);

      if (wrongGuesses == hanged) {
        _onChange.add(fullWord);
        _onLose.add(null);
      }
    }
  }

  String get wordForDisplay => wordToGuess.map((String letter) => lettersGuessed.contains(letter) ? letter : "_").join();
  String get fullWord => wordToGuess.join();

  bool get isWordComplete {
    for (String letter in wordToGuess) {
      if (!lettersGuessed.contains(letter)) {
        return false;
      }
    }

    return true;
  }
}