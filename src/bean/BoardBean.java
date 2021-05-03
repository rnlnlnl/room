package bean;

import java.sql.Timestamp;

public class BoardBean {
	private int postno;
	private String postcate;
	private String title;
	private String content;
	private String writer;
	private Timestamp writedate;
	private int scope;
	private int viewScope;
	private String noticecate;
	private int answerNo;
	private String answerCate;

	public int getAnswerNo() {
		return answerNo;
	}

	public String getAnswerCate() {
		return answerCate;
	}

	public void setAnswerNo(int answerNo) {
		this.answerNo = answerNo;
	}

	public void setAnswerCate(String answerCate) {
		this.answerCate = answerCate;
	}

	public BoardBean(int postno, String postcate, String title, String content, String writer, Timestamp writedate, int scope) {
		this.postno = postno;
		this.postcate = postcate;
		this.title = title;
		this.content = content;
		this.writer = writer;
		this.writedate = writedate;
		this.scope = scope;
	}

	public BoardBean() {

	}

	public BoardBean(String writer, int scope, String postcate, String title, String content) {
		this.writer = writer;
		this.scope = scope;
		this.postcate = postcate;
		this.title = title;
		this.content = content;
	}

	public BoardBean(int postno, String postcate, String title, String content, Timestamp writedate, String noticecate) {
		super();
		this.postno = postno;
		this.postcate = postcate;
		this.title = title;
		this.content = content;
		this.writedate = writedate;
		this.noticecate = noticecate;
	}

	public BoardBean(String postcate, String title, String content, String writer, String noticecate) {
		this.postcate = postcate;
		this.title = title;
		this.content = content;
		this.writer = writer;
		this.noticecate = noticecate;
	}

	public int getPostno() {
		return postno;
	}

	public void setPostno(int postno) {
		this.postno = postno;
	}

	public String getPostcate() {
		return postcate;
	}

	public void setPostcate(String postcate) {
		this.postcate = postcate;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
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

	public int getScope() {
		return scope;
	}

	public void setScope(int scope) {
		this.scope = scope;
	}

	public int getViewScope() {
		return viewScope;
	}

	public void setViewScope(int viewScope) {
		this.viewScope = viewScope;
	}

	public String getNoticecate() {
		return noticecate;
	}

	public void setNoticecate(String noticecate) {
		this.noticecate = noticecate;
	}

}
