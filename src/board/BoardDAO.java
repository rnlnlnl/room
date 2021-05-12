package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import bean.BoardBean;
import bean.ItemBean;
import bean.MemberBean;

public class BoardDAO {

	// 커넥션,프리페어드스테이트먼트,리설트셋 미리 선언해뒀습니다
	// 아래의 이름으로 사용해 주세요

	Connection conn = null;
	PreparedStatement pst = null;
	ResultSet res = null;
	DataSource ds = null;

	String sql;

	// 커넥션풀 얻는 메소드
	private Connection getConnection() throws Exception {
		Connection conn = null;
		Context init = new InitialContext();
		DataSource ds = (DataSource) init.lookup("java:comp/env/jdbc/roomdy");

		// 커넥션풀 얻기
		conn = ds.getConnection();
		return conn;
	}// getConnection()메서드 끝

	// 자원 반납메소드
	private void closeAll(Connection conn, PreparedStatement pst, ResultSet res) {
		try {
			if (conn != null)
				conn.close();
			if (pst != null)
				pst.close();
			if (res != null)
				res.close();
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("BoardDAO : closeAll(자원 반납 작업)에서 에러" + e);
		}
	}// closeAll()메서드 끝

	public List<BoardBean> listPost(String id, String postcate, int startRow, int pageSize) {
		List<BoardBean> postList = new ArrayList<BoardBean>();

		try { //커넥션 플로부터 커넥션 얻기(DB접속)
			conn = getConnection();

			if (postcate.equals("faq")) {
				sql = "SELECT * FROM dyboard WHERE postCate = ? ORDER BY viewscope limit ?, ?";

				pst = conn.prepareStatement(sql);

				pst.setString(1, postcate);
				pst.setInt(2, startRow);
				pst.setInt(3, pageSize);

				res = pst.executeQuery();
			}
			else if (postcate.equals("qna") && id.equals("admin")) {
				sql = "SELECT * FROM dyboard WHERE postCate = ? ORDER BY writeDate limit ?, ?";

				pst = conn.prepareStatement(sql);

				pst.setString(1, postcate);
				pst.setInt(2, startRow);
				pst.setInt(3, pageSize);

				res = pst.executeQuery();

				//admin계정으로 접속시 모든 1:1문의 확인 가능함
			}
			else if (postcate.equals("qna")) {
				sql = "SELECT * FROM dyboard WHERE postCate = ? and writer = ? ORDER BY writeDate limit ?, ?";

				pst = conn.prepareStatement(sql);

				pst.setString(1, postcate);
				pst.setString(2, id);
				pst.setInt(3, startRow);
				pst.setInt(4, pageSize);

				res = pst.executeQuery();
			}
			else if (postcate.equals("notice") || postcate.equals("review")) {
				sql = "SELECT * FROM dyboard WHERE postCate = ? ORDER BY writeDate desc limit ?, ?";

				pst = conn.prepareStatement(sql);

				pst.setString(1, postcate);
				pst.setInt(2, startRow);
				pst.setInt(3, pageSize);

				res = pst.executeQuery();
			}

			while (res.next()) {
				BoardBean bBean = new BoardBean();

				bBean.setPostno(res.getInt("postNo"));
				bBean.setTitle(res.getString("title"));
				bBean.setWritedate(res.getTimestamp("writeDate"));
				bBean.setWriter(res.getString("writer"));
				bBean.setViewScope(res.getInt("viewScope"));
				bBean.setNoticecate(res.getString("noticecate"));
				bBean.setScope(res.getInt("scope"));

				postList.add(bBean);
			}
		} catch (Exception e) {
			System.out.println("BoardDAO : listPost에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}

		return postList;
	}

	public int countPost(String postcate) {
		int postCount = 0;

		try { //커넥션 플로부터 커넥션 얻기(DB접속)
			conn = getConnection();

			sql = "SELECT count(*) FROM dyboard WHERE postCate = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, postcate);

			res = pst.executeQuery();

			if (res.next()) {
				postCount = res.getInt(1);
			}
		} catch (Exception e) {
			System.out.println("BoardDAO : countPost에서 에러" + e);
		} finally {
			closeAll(conn, pst, res);
		}

		return postCount;
	}

	public void addPost(Map<String, Object> postMap) {

		BoardBean boardBean = (BoardBean) postMap.get("boardBean");
		List<String> fileList = (List<String>) postMap.get("fileList");

		try {
			conn = getConnection();

			sql = "select max(postNo) from dyboard where postcate = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, boardBean.getPostcate());

			res = pst.executeQuery();

			int postNo = 0;

			if (res.next()) {
				postNo = res.getInt(1) + 1;
			}

			sql = "insert into dyboard (postNo, postCate, title, content, writer, noticecate) values(?,?,?,?,?,?)";

			pst = conn.prepareStatement(sql);
			pst.setInt(1, postNo);
			pst.setString(2, boardBean.getPostcate());
			pst.setString(3, boardBean.getTitle());
			pst.setString(4, boardBean.getContent());
			pst.setString(5, boardBean.getWriter());
			pst.setString(6, boardBean.getNoticecate());

			pst.executeUpdate();

			FileUpload(boardBean.getPostcate(), postNo, fileList);

		} catch (Exception e) {
			System.out.println("BoardDAO : addPost에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}
	}

	public void addAnswer(BoardBean boardBean) {
		try {
			conn = getConnection();

			sql = "select max(postNo) from dyboard where postcate = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, boardBean.getPostcate());

			res = pst.executeQuery();

			int postNo = 0;

			if (res.next()) {
				postNo = res.getInt(1) + 1;
			}

			sql = "insert into dyboard (postNo, postCate, title, content, writer, answercate, answerno) values(?,?,?,?,?,?,?)";

			pst = conn.prepareStatement(sql);
			pst.setInt(1, postNo);
			pst.setString(2, boardBean.getPostcate());
			pst.setString(3, boardBean.getTitle());
			pst.setString(4, boardBean.getContent());
			pst.setString(5, boardBean.getWriter());
			pst.setString(6, boardBean.getAnswerCate());
			pst.setInt(7, boardBean.getAnswerNo());

			pst.executeUpdate();
		} catch (Exception e) {
			System.out.println("BoardDAO : addPost에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}
	}

	public Map<String, Object> readPost(int postNo, String postCate) {
		Map<String, Object> postMap = new HashMap<String, Object>();

		BoardBean boardBean = new BoardBean();
		List<String> fileList = new ArrayList<String>();

		try {
			conn = getConnection();

			//조회수 증가 메서드
			sql = "UPDATE dyboard SET viewScope=viewScope+1 WHERE postNo = ? and postCate= ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, postNo);
			pst.setString(2, postCate);

			pst.executeUpdate();

			//글 1개의 정보 select
			sql = "SELECT * FROM dyboard WHERE postNo = ? and postCate= ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, postNo);
			pst.setString(2, postCate);

			res = pst.executeQuery();

			if (res.next()) {
				boardBean.setTitle(res.getString("title"));
				boardBean.setContent(res.getString("content"));
				boardBean.setWriter(res.getString("writer"));
				boardBean.setWritedate(res.getTimestamp("writedate"));
				boardBean.setScope(res.getInt("scope"));
				boardBean.setViewScope(res.getInt("viewScope"));
				boardBean.setNoticecate(res.getString("noticecate"));
			}

			fileList = getFileList(postCate, postNo);

			postMap.put("boardBean", boardBean);
			postMap.put("fileList", fileList);

		} catch (Exception e) {
			System.out.println("BoardDAO : readPost(글 하나를  보는 작업)에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}
		return postMap;
	}

	public void modPost(BoardBean boardBean) {
		try {
			conn = getConnection();

			sql = "UPDATE dyboard SET title = ?, content = ?, writeDate = ?, noticecate = ? WHERE postNo = ? AND postCate = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, boardBean.getTitle());
			pst.setString(2, boardBean.getContent());
			pst.setTimestamp(3, boardBean.getWritedate());
			pst.setString(4, boardBean.getNoticecate());
			pst.setInt(5, boardBean.getPostno());
			pst.setString(6, boardBean.getPostcate());

			pst.executeUpdate();

		} catch (Exception e) {
			System.out.println("BoardDAO : modPost에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}

	}

	public boolean delPost(int postNo, String postCate) {
		boolean result = false;

		try {
			conn = getConnection();

			sql = "DELETE FROM dyboard WHERE postNo = ? AND postCate = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, postNo);
			pst.setString(2, postCate);

			pst.executeUpdate();

			result = true;
		} catch (Exception e) {
			System.out.println("BoardDAO : delPost에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}

		return result;
	}

	public void addReview(Map<String, Object> reviewMap) {
		BoardBean boardBean = (BoardBean) reviewMap.get("boardBean");
		List<String> fileList = (List<String>) reviewMap.get("fileList");
		int orderNo = (int) reviewMap.get("orderNo");

		try {
			conn = getConnection();

			sql = "select max(postNo) from dyboard where postcate = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, boardBean.getPostcate());

			res = pst.executeQuery();

			int postNo = 0;

			if (res.next()) {
				postNo = res.getInt(1) + 1;
			}

			sql = "insert into dyboard (postNo, postCate, title, content, writer, scope) values(?,?,?,?,?,?)";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, postNo);
			pst.setString(2, boardBean.getPostcate());
			pst.setString(3, boardBean.getTitle());
			pst.setString(4, boardBean.getContent());
			pst.setString(5, boardBean.getWriter());
			pst.setInt(6, boardBean.getScope());

			pst.executeUpdate();

			FileUpload(boardBean.getPostcate(), postNo, fileList);

			sql = "update dyorderitem set reviewno = ? where orderno = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, postNo);
			pst.setInt(2, orderNo);

			pst.executeUpdate();
		} catch (Exception e) {
			System.out.println("BoardDAO : addReview에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}

	}

	public List<Map<String, Object>> sortByBoardList(String id, String sortBy, String postCate, int startRow, int pageSize) {
		List<Map<String, Object>> reviewList = new ArrayList<Map<String, Object>>();

		try {
			conn = getConnection();

			sql = "select dyitem.itemname, dyitem.cost, dyitem.itemCate, dyboard.title, dyboard.scope from dyorderitem join dyboard on dyboard.postNo = dyorderitem.reviewNo and dyboard.postCate = 'review' join dyitem on dyorderitem.itemNo = dyitem.itemNo order by dyboard.scope desc limit ?, ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, startRow);
			pst.setInt(2, pageSize);

			res = pst.executeQuery();

			while (res.next()) {
				Map<String, Object> review = new HashMap<String, Object>();

				BoardBean boardBean = new BoardBean();
				ItemBean itemBean = new ItemBean();

				boardBean.setTitle(res.getString("title"));
				boardBean.setScope(res.getInt("scope"));
				itemBean.setItemname(res.getString("itemname"));
				itemBean.setItemCate(res.getString("itemCate"));
				itemBean.setCost(res.getInt("cost"));

				review.put("boardBean", boardBean);
				review.put("itemBean", itemBean);

				reviewList.add(review);
			}
		} catch (Exception e) {
			System.out.println("BoardDAO : addReview에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}

		return reviewList;
	}

	public List listReview(int itemNo, int startRow, int pageSize) {
		List<Map<String, Object>> reviewList = new ArrayList<Map<String, Object>>();

		try {
			conn = getConnection();

			sql = "SELECT dyboard.postno, itemname, cost, dyboard.title, dyboard.scope, dyfile.fileSrc, dyboard.writer, dyboard.writeDate " + "FROM dyorderitem " + "JOIN dyboard ON dyboard.postNo = dyorderitem.reviewNo AND dyboard.postCate = 'review' " + "JOIN dyitem ON dyorderitem.itemNo = dyitem.itemNo " + "JOIN dyfile ON dyboard.postNo = dyfile.postNo AND dyboard.postCate = dyfile.postCate " + "where fileno = 0 ";

			if (itemNo > 0) {
				sql += "and dyitem.itemno = ? ";
			}
			
			sql += "order by writeDate desc limit ?, ?";

			pst = conn.prepareStatement(sql);

			if (itemNo < 0) {
				pst.setInt(1, startRow);
				pst.setInt(2, pageSize);
			}
			else {
				pst.setInt(1, itemNo);
				pst.setInt(2, startRow);
				pst.setInt(3, pageSize);
			}

			res = pst.executeQuery();

			while (res.next()) {
				Map<String, Object> review = new HashMap<String, Object>();

				BoardBean boardBean = new BoardBean();
				ItemBean itemBean = new ItemBean();

				itemBean.setItemname(res.getString("itemname"));
				itemBean.setCost(res.getInt("cost"));

				boardBean.setPostno(res.getInt("postno"));
				boardBean.setTitle(res.getString("title"));
				boardBean.setScope(res.getInt("scope"));
				boardBean.setWriter(res.getString("writer"));
				boardBean.setWritedate(res.getTimestamp("writeDate"));

				String fileSrc = res.getString("fileSrc");

				review.put("itemBean", itemBean);
				review.put("boardBean", boardBean);
				review.put("fileSrc", fileSrc);

				reviewList.add(review);
			}
		} catch (Exception e) {
			System.out.println("BoardDAO : listReview에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}

		return reviewList;
	}

	public List<BoardBean> listAnswer(String postCate, int postNo) {
		List<BoardBean> answerList = new ArrayList<BoardBean>();

		try {
			conn = getConnection();

			sql = "SELECT * FROM dyboard WHERE answerCate = ? and answerNo = ?";

			pst = conn.prepareStatement(sql);

			pst.setString(1, postCate);
			pst.setInt(2, postNo);

			res = pst.executeQuery();

			while (res.next()) {
				BoardBean bBean = new BoardBean();

				bBean.setPostno(res.getInt("postNo"));
				bBean.setTitle(res.getString("title"));
				bBean.setWritedate(res.getTimestamp("writeDate"));
				bBean.setContent(res.getString("content"));

				answerList.add(bBean);
			}
		} catch (Exception e) {
			System.out.println("BoardDAO : answerList에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}

		return answerList;
	}

	public Map<String, Object> readReview(int postNo) {

		Map<String, Object> reviewMap = new HashMap<String, Object>();

		ItemBean itemBean = new ItemBean();
		BoardBean boardBean = new BoardBean();
		List<String> fileList = new ArrayList<String>();

		try {
			conn = getConnection();

			sql = "SELECT itemname, dyitem.itemno, postno, title, writer, content, scope, writedate " + "FROM dyorderitem " + "JOIN dyboard ON dyboard.postNo = dyorderitem.reviewNo " + "JOIN dyitem ON dyitem.itemNo = dyorderitem.itemNo " + "WHERE reviewno = ? AND postcate = 'review'";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, postNo);

			res = pst.executeQuery();

			if (res.next()) {
				itemBean.setItemname(res.getString("itemname"));
				itemBean.setItemno(res.getInt("itemno"));
				boardBean.setPostno(res.getInt("postno"));
				boardBean.setTitle(res.getString("title"));
				boardBean.setWriter(res.getString("writer"));
				boardBean.setWritedate(res.getTimestamp("writedate"));
				boardBean.setContent(res.getString("content"));
				boardBean.setScope(res.getInt("scope"));
			}

			fileList = getFileList("review", boardBean.getPostno());
		} catch (Exception e) {
			System.out.println("BoardDAO : listReview에서 에러" + e);
			e.printStackTrace();
		} finally {
			closeAll(conn, pst, res);
		}

		reviewMap.put("itemBean", itemBean);
		reviewMap.put("boardBean", boardBean);
		reviewMap.put("fileList", fileList);

		return reviewMap;
	}

	public void FileUpload(String postCate, int postNo, List<String> fileList) {
		try {

			//다른 db 연결하는 메서드에서 호출하는 메서드이므로 conn이 이미 생성되어있음 따라서 따로 생성 xx
			//마찬가지로 해제도 하면 안됨

			for (int i = 0; i < fileList.size(); i++) {

				sql = "INSERT INTO dyfile (postNo, postCate, fileNo, fileSrc) VALUES (?, ?, ?, ?)";

				pst = conn.prepareStatement(sql);

				pst.setInt(1, postNo);
				pst.setString(2, postCate);
				pst.setInt(3, i);
				pst.setString(4, fileList.get(i));

				pst.executeUpdate();
			}
		} catch (Exception e) {
			System.out.println("BoardDAO : FileUpload에서 에러" + e);
			e.printStackTrace();
		}
	}

	public List<String> getFileList(String postCate, int postNo) {
		List<String> fileList = new ArrayList<String>();

		try {

			//다른 db 연결하는 메서드에서 호출하는 메서드이므로 conn이 이미 생성되어있음 따라서 따로 생성 xx
			//마찬가지로 해제도 하면 안됨

			sql = "SELECT fileSrc FROM dyfile WHERE postno = ? AND postcate = ?";

			pst = conn.prepareStatement(sql);

			pst.setInt(1, postNo);
			pst.setString(2, postCate);

			res = pst.executeQuery();

			while (res.next()) {
				fileList.add(res.getString(1));
			}

		} catch (Exception e) {
			System.out.println("BoardDAO : getFileList에서 에러" + e);
			e.printStackTrace();
		}

		return fileList;
	}
}
