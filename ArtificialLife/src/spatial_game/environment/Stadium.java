package spatial_game.environment;

public class Stadium {
	
	public int width, height;
	public Player[][] players;
	public int iterations;
	public int[][] cost;
	public int[][] draw;
	
	public Stadium(int width, int height, int iterations) {
		this.players = new Player[width][height];
		this.draw = new int[width][height];
		for(int i = 0; i < width; i++)
			for(int j = 0; j < height; j++) {
				this.players[i][j] = new Player(1 + (int) (Math.random() * 5));
				this.draw[i][j] = (i * width) + j;
			}
		this.iterations = iterations;
		this.width = width;
		this.height = height;
		this.cost = new int[][]{{3, 8}, {1, 4}};
	}
	
	public int[][] play() {
		int[][] wins = new int[width][height];
		for(int i = 0; i < width; i++)
			for(int j = 0; j < height; j++)
				wins[i][j] = play(i, j);
		return wins;
	}

	public int play(int x, int y) {
		int cnt = 0;
		for(int i = -1; i < 2; i++)
			for(int j = -1; j < 2; j++) {
				if(!(i == 0 && j == 0)) {
					int f = (width + (x + i) % width) % width;
					int c = (height + (y + j) % height) % height;
					cnt += play(players[x][y], players[f][c]);
				}
			}
		return cnt;
	}

	public int play(Player player1, Player player2) {
		int[] des1 = new int[iterations];
		int[] des2 = new int[iterations];
		int tot = 0;
		
		for(int i = 0; i < iterations; i++) {
			int input1 = 0, input2 = 0;
			for(int j = 1; j <= player1.length; j++)
				if(i - j >= 0) {
					input1 = (input1 << 1) + des1[i - j];
					input1 = (input1 << 1) + des2[i - j];
				} else {
					input1 <<= 2;
				}
			for(int j = 1; j <= player2.length; j++)
				if(i - j >= 0) {
					input2 = (input2 << 1) + des2[i - j];
					input2 = (input2 << 1) + des1[i - j];
				} else {
					input2 <<= 2;
				}
			des1[i] = player1.play(input1);
			des2[i] = player2.play(input2);
			tot += cost[des1[i]][des2[i]];
		}
		return tot;
	}
	
	public void replace(int[][] wins) {
		Player[][] next = new Player[width][height];
		for(int i = 0; i < width; i++)
			for(int j = 0; j < height; j++)
				replace(next, wins, i, j);
		players = next;
	}

	private void replace(Player[][] next, int[][] wins, int x, int y) {
		next[x][y] = players[x][y].clone();
		for(int i = -1; i < 2; i++)
			for(int j = -1; j < 2; j++) {
				int f = (width + (x + i) % width) % width;
				int c = (height + (y + j) % height) % height;
				if(wins[x][y] < wins[f][c]) {
					next[x][y] = players[f][c].clone();
					draw[x][y] = draw[f][c];
				}
			}
	}

}
