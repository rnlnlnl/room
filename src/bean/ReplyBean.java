package bean;

import java.sql.Timestamp;

public class ReplyBean {
	private int postno;
	private String postCate;
	private int replyno;
	private String writer;
	private Timestamp writedate;
	private int good;
	private int bad;

	public ReplyBean() {
	}

	public ReplyBean(int postno, String postCate, int replyno, String writer, Timestamp writedate, int good, int bad) {
		this.postno = postno;
		this.postCate = postCate;
		this.replyno = replyno;
		this.writer = writer;
		this.writedate = writedate;
		this.good = good;
		this.bad = bad;
	}

	public int getPostno() {
		return postno;
	}

	public void setPostno(int postno) {
		this.postno = postno;
	}

	public String getPostCate() {
		return postCate;
	}

	public void setPostCate(String postCate) {
		this.postCate = postCate;
	}

	public int getReplyno() {
		return replyno;
	}

	public void setReplyno(int replyno) {
		this.replyno = replyno;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public Timestamp getWritedate() {
		return writedate;
	}

	public void setWritedate(Timestamp writedate) {
		this.writedate = writedate;
	}

	public int getGood() {
		return good;
	}

	public void setGood(int good) {
		this.good = good;
	}

	public int getBad() {
		return bad;
	}

	public void setBad(int bad) {
		this.bad = bad;
	}
}
