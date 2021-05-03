package bean;

public class FileBean {

	private int postno;
	private String postCate;
	private int fileno;
	private String filesrc;

	public FileBean(int postno, String postCate, int fileno, String filesrc) {
		this.postno = postno;
		this.postCate = postCate;
		this.fileno = fileno;
		this.filesrc = filesrc;
	}

	public FileBean() {
	}

	public int getPostno() {
		return postno;
	}

	public void setPostno(int postno) {
		this.postno = postno;
	}

	public int getFileno() {
		return fileno;
	}

	public void setFileno(int fileno) {
		this.fileno = fileno;
	}

	public String getFilesrc() {
		return filesrc;
	}

	public void setFilesrc(String filesrc) {
		this.filesrc = filesrc;
	}

	public String getPostCate() {
		return postCate;
	}

	public void setPostCate(String postCate) {
		this.postCate = postCate;
	}

}
