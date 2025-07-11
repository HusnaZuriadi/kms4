package kms.model;

import java.sql.Date;

public class StudentProgress {
	
		private int progressId;
		private int marks;
		private Date months;
		private String teacherComment;
		
		public int getProgressId() {
			return progressId;
		}
		public void setProgressId(int progressId) {
			this.progressId = progressId;
		}

		public int getMarks() {
			return marks;
		}
		public void setMarks(int marks) {
			this.marks = marks;
		}
		public Date getMonths() {
			return months;
		}
		public void setMonths(Date months) {
			this.months = months;
		}
		public String getTeacherComment() {
			return teacherComment;
		}
		public void setTeacherComment(String teacherComment) {
			this.teacherComment = teacherComment;
		}
}
