package kms.model;

import java.io.Serializable;

public class enrollment implements Serializable {

    private static final long serialVersionUID = 1L;
    private int enrollId;
    private int studId;
    private int subjectId;
    private int progressId;
    
    public enrollment () {
    	
    }

	public int getEnrollId() {
		return enrollId;
	}

	public void setEnrollId(int enrollId) {
		this.enrollId = enrollId;
	}

	public int getStudId() {
		return studId;
	}

	public void setStudId(int studId) {
		this.studId = studId;
	}

	public int getSubjectId() {
		return subjectId;
	}

	public void setSubjectId(int subjectId) {
		this.subjectId = subjectId;
	}

	public int getProgressId() {
		return progressId;
	}

	public void setProgressId(int progressId) {
		this.progressId = progressId;
	}
    
    


}
