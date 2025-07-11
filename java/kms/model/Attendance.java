package kms.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;


public class Attendance implements Serializable {

    private static final long serialVersionUID = 1L;

    private int attendanceId;
    private Date attendanceDate;
    private int studId; // Store student ID
    private Timestamp checkinTime;
    private Timestamp checkoutTime;
    private String attendanceStatus;
    private double checkinTemp;
    
    
    public int getAttendanceId() {
		return attendanceId;
	}

	public void setAttendanceId(int attendanceId) {
		this.attendanceId = attendanceId;
	}

	public Date getAttendanceDate() {
		return attendanceDate;
	}

	public void setAttendanceDate(Date attendanceDate) {
		this.attendanceDate = attendanceDate;
	}

	public int getStudId() {
		return studId;
	}

	public void setStudId(int studId) {
		this.studId = studId;
	}

	public Timestamp getCheckinTime() {
		return checkinTime;
	}

	public void setCheckinTime(Timestamp checkinTime) {
		this.checkinTime = checkinTime;
	}

	public Timestamp getCheckoutTime() {
		return checkoutTime;
	}

	public void setCheckoutTime(Timestamp checkoutTime) {
		this.checkoutTime = checkoutTime;
	}

	public String getAttendanceStatus() {
		return attendanceStatus;
	}

	public void setAttendanceStatus(String attendanceStatus) {
		this.attendanceStatus = attendanceStatus;
	}

	public double getCheckinTemp() {
		return checkinTemp;
	}

	public void setCheckinTemp(double checkinTemp) {
		this.checkinTemp = checkinTemp;
	}  
	
	private String studName;

	public String getStudName() {
	    return studName;
	}

	public void setStudName(String studName) {
	    this.studName = studName;
	}

    
}
