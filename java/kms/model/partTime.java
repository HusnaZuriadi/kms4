package kms.model;

public class partTime extends teacher implements java.io.Serializable {
    private static final long serialVersionUID = 1L;
    private Integer contract;
    private Double hourlyRate;

	public Integer getContract() {
		return contract;
	}

	public void setContract(Integer contract) {
		this.contract = contract;
	}

	public Double getHourlyRate() {
		return hourlyRate;
	}

	public void setHourlyRate(Double hourlyRate) {
		this.hourlyRate = hourlyRate;
	}
    
    

}
