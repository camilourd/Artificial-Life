package optimization;

public class optimiza {
	
	public static double[] random(double[] min, double[] max) {
		double[] x = new double[min.length];
		for(int i = 0; i < x.length; i++)
			x[i] = min[i] + Math.random() * (max[i] - min[i]);
		return x;
	}
	
	public static double apply(double x) {
		return x * x - 10.0 * Math.cos(2.0 * Math.PI * x);
	}
	
	public static double f(double[] x) {
		int d = x.length;
		double f = 10.0 * d;
		for(int i = 0; i < d; i++) {
			f += apply(x[i]);
		}
		return f;
	}
	
	public static double powerLaw() {
		double coarse_alpha = -0.12;
		double var = Math.pow(1.0 - Math.random(), coarse_alpha);
		if(Math.random() < 0.5)
			return -var;
		return var;
	}
	
	public static double[] min(int n) {
		double[] m = new double[n];
		for(int i = 0; i < n; i++) {
			m[i] = -5.12;
		}
		return m;
	}
	
	public static double[] max(int n) {
		double[] m = new double[n];
		for(int i = 0; i < n; i++) {
			m[i] = 5.12;
		}
		return m;
	}
	
	public static double[] repair(double[] x, double[] min, double[] max) {
		double[] y = x.clone();
		for(int i = 0; i < x.length; i++) {
			y[i] = (y[i] < min[i])? min[i] : ((y[i] > max[i])? max[i] : y[i]);
		}
		return y;
	}
	
	public static double[] hillClimbing(int MAXITERS) {
		double[] min = min(10), max = max(10);
		double[] x = random(min, max);
		double fx = f(x);
		System.out.println("0 : " + fx);
		for(int i = 1; i <= MAXITERS; i++) {
			double[] y = variation(x);
			y = repair(y, min, max);
			double fy = f(y);
			if(fy <= fx) {
				x = y;
				fx = fy;
			}
			System.out.println(i + " : " + fx);
		}
		return x;
	}
	
	public static double generate() {
		double x, y;
		double r;
		do {
			x = 2.0 * Math.random() - 1.0;
			y = 2.0 * Math.random() - 1.0;
			r = x * x + y * y;
		} while(r >= 1.0);
		double z = Math.sqrt(-2.0 * Math.log(r) / r);
		return (y * z);
	}

	public static double[] variation(double[] x) {
		double sigma = 0.9;
		double[] y = x.clone();
		for(int i = 0; i < y.length; i++) {
			y[i] += powerLaw() * sigma;
		}
		return y;
	}

	public static void main(String[] args) {
		hillClimbing(10000);
	}

}
