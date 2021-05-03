package board;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import bean.BoardBean;
import bean.MemberBean;
import member.MemberDAO;

public class BoardService {

	BoardDAO bDAO;

	public BoardService() {
		// 객체 생성시 자동으로 dao 객체 생성
		bDAO = new BoardDAO();
	}

	public List<BoardBean> listPost(String id, String postcate, int startRow, int pageSize) {
		List<BoardBean> postList = bDAO.listPost(id, postcate, startRow, pageSize);

		return postList;
	}

	public int countPost(String postcate) {
		int postCount = bDAO.countPost(postcate);

		return postCount;
	}

	public void addPost(Map<String, Object> postMap) {
		bDAO.addPost(postMap);
	}

	public Map<String, Object> readPost(int postNo, String postCate) {
		Map<String, Object> postMap = bDAO.readPost(postNo, postCate);
		return postMap;
	}

	public void modPost(BoardBean boardBean) {
		bDAO.modPost(boardBean);
	}

	public boolean delPost(int postNo, String postCate) {
		boolean result = bDAO.delPost(postNo, postCate);

		return result;
	}

	public List<Map<String, Object>> sortByBoardList(String id, String sortBy, String postCate, int startRow, int pageSize) {
		List<Map<String, Object>> reviewList = bDAO.sortByBoardList(id, sortBy, postCate, startRow, pageSize);
		return reviewList;
	}

	public void addReview(Map<String, Object> reviewMap) {
		bDAO.addReview(reviewMap);

	}

	public List listReview(int itemNo, int startRow, int pageSize) {
		List reviewList = bDAO.listReview(itemNo, startRow, pageSize);
		return reviewList;
	}

	public Map<String, Object> readReview(int postNo) {
		Map<String, Object> reviewMap = bDAO.readReview(postNo);

		return reviewMap;
	}

	public List<BoardBean> listAnswer(String postCate, int postNo) {
		List<BoardBean> answerList = bDAO.listAnswer(postCate, postNo);

		return answerList;
	}

	public void addAnswer(BoardBean boardBean) {
		bDAO.addAnswer(boardBean);
	}
}
