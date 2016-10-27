package optimization;

public class Mutation {
	
	public boolean[] apply(boolean[] genome) {
		boolean[] child = genome.clone();
		double mutation_probability = 1.0 / (double) child.length;
		for(int i = 0; i < child.length; i++)
			if(Math.random() < mutation_probability)
				child[i] = !child[i];
		return child;
	}

}
