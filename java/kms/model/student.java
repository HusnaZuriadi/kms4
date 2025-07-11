package kms.model;

import java.io.Serializable;
import java.sql.Date;
import java.time.LocalDate;
import java.io.InputStream;

public class student implements Serializable {
	private static final long serialVersionUID = 1L;
	private int studId;
	private String studName;
	private String studGender;
	private String studAddress;
	private Date studBirthDate;
	private int parentId;
	private byte[] studPhoto;
	private byte[] studBirthCert;


	public student() {

	}

	public int getStudId() {
		return studId;
	}

	public void setStudId(int studId) {
		this.studId = studId;
	}

	public String getStudName() {
		return studName;
	}

	public void setStudName(String studName) {
		this.studName = studName;
	}

	
	public String getStudGender() {
		return studGender;
	}

	public void setStudGender(String studGender) {
		this.studGender = studGender;
	}

	public String getStudAddress() {
		return studAddress;
	}

	public void setStudAddress(String studAddress) {
		this.studAddress = studAddress;
	}

	public Date getStudBirthDate() {
		return studBirthDate;
	}

	public void setStudBirthDate(Date studBirthDate) {
		this.studBirthDate = studBirthDate;
	}

	public int getParentId() {
		return parentId;
	}

	public void setParentId(int parentId) {
		this.parentId = parentId;
	}

	public byte[] getStudPhoto() {
		return studPhoto;
	}

	public void setStudPhoto(byte[] studPhoto) {
		this.studPhoto = studPhoto;
	}

	public byte[] getStudBirthCert() {
		return studBirthCert;
	}

	public void setStudBirthCert(byte[] studBirthCert) {
		this.studBirthCert = studBirthCert;
	}
	
	// calculate age based on birth year only
		public int getAge() {
			if (studBirthDate == null) return 0;

			LocalDate birthDate = studBirthDate.toLocalDate();
			LocalDate today = LocalDate.now();

			return today.getYear() - birthDate.getYear();
		}
	
}
