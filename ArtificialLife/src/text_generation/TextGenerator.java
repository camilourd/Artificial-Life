package text_generation;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Map;

import unalcol.random.real.UniformGenerator;

public class TextGenerator {
	
	public static void cleanText(String text, String result) throws IOException {
		BufferedReader  in = new BufferedReader (new InputStreamReader (new FileInputStream (text), "utf-8"));
		BufferedWriter  out = new BufferedWriter (new OutputStreamWriter (new FileOutputStream (result), "utf-8"));
		
		for(String line = ""; (line = in.readLine()) != null;) {
			line = (line.toLowerCase()).replaceAll("\\d", "\n");
			line = line.replaceAll("\\.", "\n");
			line = line.replaceAll(",", "\n");
			line = line.replaceAll(";", "\n");
			line = line.replaceAll("[()]", "\n");
			line = line.replaceAll("-", "\n");
			line = line.replaceAll(":", "\n");
			line = line.replaceAll("«", "\n");
			line = line.replaceAll("»", "\n");
			line = line.replaceAll("!", "\n");
			line = line.replaceAll("¡", "\n");
			line = line.replaceAll("\\?", "\n");
			line = line.replaceAll("¿", "\n");
			line = line.replaceAll("\t", "\n");
			line = line.replaceAll("”", "\n");
			line = line.replaceAll("\\s+", " ");
			out.write(line.trim() + "\n");
		}
		in.close();
		out.close();
	}

	@SuppressWarnings("resource")
	public static void main(String[] args) throws IOException {
		String text = "./data/text_generator/text";
		String cleaned = "./data/text_generator/cleaned_text";
		int size = 8;
		int times = 200;
		
		cleanText(text, cleaned);
		
		String[] pat = new String[1000000];
		double[] probs = new double[1000000];
		Map<String, Integer> dir = new HashMap<String, Integer>();
		int total = 0, cnt = 0;
		
		BufferedReader  in = new BufferedReader (new InputStreamReader (new FileInputStream (cleaned), "utf-8"));
		
		for(String line = ""; (line = in.readLine()) != null;) {
			for(int piv = 0; piv + size < line.length(); piv++) {
				String p = line.substring(piv, piv + size);
				if(!dir.containsKey(p)) {
					dir.put(p, total);
					pat[total] = p;
					total++;
				}
				probs[dir.get(p)]++;
				cnt++;
			}
		}
		
		for(int i = 0; i < total; i++) {
			probs[i] /= (double) cnt;
			if(i > 0)
				probs[i] += probs[i - 1];
		}
		
		UniformGenerator gen = new UniformGenerator(0.0, 1.0);
		
		for(int i = 0; i < times; ++i) {
			double prob = gen.generate();
			int li = 0, ls = total - 1, mid;
			
			while(li < ls) {
				mid = (li + ls) / 2;
				if(probs[mid] < prob)
					li = mid + 1;
				else
					ls = mid;
			}
			System.out.print(pat[li]);
		}
		System.out.println();
	}

}
