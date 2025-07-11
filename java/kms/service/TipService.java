package kms.service;

import java.util.Arrays;
import java.util.List;
import java.util.Random;

public class TipService {
	
 private static final List<String> tips = Arrays.asList(
		        "Be present, listen actively, and lead by example.",
		        "Celebrate small achievements to boost your child’s confidence.",
		        "Spend quality time together every day, even if it’s just 10 minutes.",
		        "Encourage curiosity by answering questions patiently.",
		        "Teach values through stories, not just rules."
		    );

			public static String getRandomTip() {
				Random rand = new Random();
				return tips.get(rand.nextInt(tips.size()));
			}

}
