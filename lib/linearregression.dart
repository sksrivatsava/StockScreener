import "dart:math" as m;
import 'dart:convert';


class LinReg {
  dynamic gen;
  double a = 0;
  double b = 0;
  int seed = 0;
  double lambda = 0;

  LinReg.init(int seed, double lambda) {
    this.gen = m.Random(seed);
    this.seed = seed;
    this.a = gen.nextDouble();
    this.b = gen.nextDouble();
    this.lambda = lambda;
  }

  LinReg.from_json(String json) {
    var description = jsonDecode(json);
    this.gen = m.Random(description["seed"]);
    this.seed = description["seed"];
    this.a = description["a"];
    this.b = description["b"];
    this.lambda = description["lambda"];
  }

  String to_json() => jsonEncode(
      {
        "seed": this.seed,
        "a": this.a,
        "b": this.b,
        "lambda": this.lambda,
      }
  );

  double forward(double X) => this.a*X + this.b;

  num mse(double Y, double Y_hat) => m.pow(Y-Y_hat, 2);

  double dmseda(double X, double Y, double Y_hat) => -2*(Y-Y_hat)*X;

  double dmsedb(double Y, double Y_hat) => -2*(Y-Y_hat);

  void step(double X, double Y) {
    var Y_hat = this.forward(X);
    var mse = this.mse(Y, Y_hat);
    var dLda = this.dmseda(X, Y, Y_hat);
    var dLdb = this.dmsedb(Y, Y_hat);
    this.a = this.a - this.lambda*dLda;
    this.b = this.b - this.lambda*dLdb;
  }

  void fit(List<double> X, List<double> Y, int n_iter) {
    var n = X.length;
    for (var j = 0; j <= n_iter; j++) {
      for (var i = 0; i <= n-1; i++) {
        this.step(X[i], Y[i]);
      }
    }
  }

  List<double> predict(List<double> X) => List.from(Function.apply(this.forward, X));
}
