package bean;

public class OptionBean {
	private int itemNo, optNo, optCost;
	private String optName;

	public OptionBean(int optNo, int optCost, String optName) {
		this.optNo = optNo;
		this.optCost = optCost;
		this.optName = optName;
	}

	public int getItemNo() {
		return itemNo;
	}

	public int getOptNo() {
		return optNo;
	}

	public int getOptCost() {
		return optCost;
	}

	public String getOptName() {
		return optName;
	}

	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}

	public void setOptNo(int optNo) {
		this.optNo = optNo;
	}

	public void setOptCost(int optCost) {
		this.optCost = optCost;
	}

	public void setOptName(String optName) {
		this.optName = optName;
	}
}
