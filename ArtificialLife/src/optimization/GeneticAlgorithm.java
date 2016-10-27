package optimization;

public class GeneticAlgorithm {
	
	public double f(boolean[] genome) {
		double s = 0.0;
		for(int i = 0; i < genome.length; i++)
			s += (genome[i])? 1.0 : 0.0;
		return s;
	}
	
	public int[] permutate(int lambda) {
		int[] a = new int[lambda];
		for(int i = 0; i < a.length; i++)
			a[i] = i;
		for(int i = 0; i < a.length; i++) {
			int x = (int) (Math.random() * a.length);
			int y = (int) (Math.random() * a.length);
			int t = a[x];
			a[x] = a[y];
			a[y] = t;
		}
		for(int i = 0; i < a.length; i++) {
			int x = (int) (Math.random() * a.length);
			int y = (int) (Math.random() * a.length);
			int t = a[x];
			a[x] = a[y];
			a[y] = t;
		}
		return a;
	}
	
	public void permutate(boolean[][] population, double[] f) {
		boolean[][] xpopulation = population.clone();
		double[] xf = f.clone();
		int[] a = permutate(population.length);
		for(int i = 0; i < population.length; i++) {
			population[i] = xpopulation[a[i]];
			f[i] = xf[a[i]];
		}
	}
	
	public boolean[][] generate(int lambda) {
		boolean[][] population = new boolean[lambda][];
		for(int i = 0; i < lambda; i++) {
			population[i] = new boolean[30];
			for(int j = 0; j < population[i].length; j++)
				population[i][j] = (Math.random() < 0.5)? true : false;
		}
		return population;
	}
	
	public double[] evaluate(boolean[][] population) {
		double[] f = new double[population.length];
		for(int i = 0; i < population.length; i++)
			f[i] = f(population[i]);
		return f;
	}
	
	public int[] candidates(int lambda) {
		int[] c = new int[4];
		for(int i = 0; i < 4; i++) {
			c[i] = (int) (Math.random() * lambda);
		}
		return c;
	}
	
	public String print(boolean[] x) {
		StringBuilder sb = new StringBuilder();
		for(Boolean b: x)
			sb.append(b? '1' : '0');
		return sb.toString();
	}
	
	public int best(double[] f) {
		int b = 0;
		for(int i = 1; i < f.length; i++)
			if(f[b] < f[i])
				b = i;
		return b;
	}
	
	public void apply(int lambda, int N) {
		Tournament sel = new Tournament();
		XOver xover = new XOver();
		Mutation mut = new Mutation();
		boolean[][] population = generate(lambda);
		double[] f = evaluate(population);
		System.out.println("0: " + print(population[best(f)]) + " " + f[best(f)]);
		for(int i = 1; i <= N; i++) {
			permutate(population, f);
			boolean[][] parents = new boolean[lambda][];
			double[] fparents = new double[lambda];
			for(int j = 0; j < lambda; j++) {
				int s = sel.apply(f, candidates(lambda));
				parents[j] = population[s];
				fparents[j] = f[s];
			}
			for(int k = 0; k < lambda; k += 2) {
				boolean[][] children = xover.apply(parents[k], parents[(k + 1) % lambda]);
				boolean[] child = mut.apply(children[0]);
				double fit = f(child);
				population[k] = (f[k] < fit)? child : population[k];
				child = mut.apply(children[1]);
				fit = f(child);
				population[k + 1] = (f[k + 1] < fit)? child : population[k + 1];
			}
			f = evaluate(population);
			System.out.println(i + ": " + print(population[best(f)]) + " " + f[best(f)]);
		}
	}
	
	public static void main(String[] args) {
		GeneticAlgorithm ga = new GeneticAlgorithm();
		ga.apply(100, 100);
	}

}
