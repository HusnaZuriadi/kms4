package kms.helper;

import java.sql.Date;
import java.time.LocalDate;

public class CalculateAge {
	
	public static int calculateAgeStud(Date birthDate) {
        if (birthDate == null) return 0;

        LocalDate dob = birthDate.toLocalDate();
        LocalDate today = LocalDate.now();

        // Tolak tahun sekarang dengan tahun lahir
        return today.getYear() - dob.getYear();
    }

}
