package optimization;

public class Tournament {
	
	public int compete(double[] f, int a, int b) {
		double sum = f[a] + f[b];
		if(sum == 0.0)
			return (Math.random() < 0.5)? a : b;
		return (Math.random() < (f[a] / sum))? a : b;
	}
	
	public int apply(double[] f, int[] candidates) {
		int s1 = (candidates[0] == compete(f, candidates[0], candidates[1]))? 0 : 1;
		int s2 = (candidates[2] == compete(f, candidates[2], candidates[3]))? 2 : 3;
		return compete(f, candidates[s1], candidates[s2]);
	}

}
