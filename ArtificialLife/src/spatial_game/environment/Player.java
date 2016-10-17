package spatial_game.environment;

public class Player {
	
	public int[] rules;
	public int length;
	
	public Player(int length) {
		int tot = (int) Math.pow(2, 2 * length);
		rules = new int[tot];
		for(int i = 0; i < tot; i++)
			rules[i] = (Math.random() < 0.5)? 0 : 1;
		this.length = length;
	}
	
	public Player(int length, int[] rules) {
		this.length = length;
		this.rules = rules;
	}
	
	int play(int input) {
		return rules[input];
	}

	@Override
	public String toString() {
		String des = "Strategy:\n";
		for(int i = 0; i < rules.length; i++) {
			String player = "";
			String opponent = "";
			int aux = i;
			for(int j = 0; j < length; j++) {
				opponent += (aux % 2 == 1)? 'D' : 'C';
				aux >>= 1;
				player += (aux % 2 == 1)? 'D' : 'C';
				aux >>= 1;
			}
			des += player + ", " + opponent + " = " + ((rules[i] == 0)? 'C' : 'D') + "\n";
		}
		return des;
	}

	@Override
	protected Player clone() {
		return new Player(length, rules);
	}

}
