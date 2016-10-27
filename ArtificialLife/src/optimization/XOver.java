package optimization;

public class XOver {
	
	public boolean[][] apply(boolean[] genome1, boolean[] genome2) {
		boolean[][] children = new boolean[][] { genome1.clone(), genome2.clone() };
		int xpoint = 1 + (int) (Math.random() * genome1.length - 1);
		for(int i = xpoint; i < genome1.length; i++) {
			children[0][i] = genome2[i];
			children[1][i] = genome1[i];
		}
		return children;
	}

}
