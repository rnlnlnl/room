package board;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import bean.BoardBean;
import bean.FileBean;
import bean.ItemBean;
import bean.OptionBean;

//컨텍스트 패스가 /board 로 시작하는 모든 요청은 이 서블릿에서 처리합니다
@WebServlet("/board/*")
public class BoardController extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doIt(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doIt(request, response);
	}

	public void doIt(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		// 뷰페이지(요청한 작업을 완료한 후 보여줄 페이지) 주소를 저장할 변수
		String nextPage = null;
		boolean isRedirect = false;

		// 이 서블릿을 요청한 페이지 주소얻기
		String path = request.getPathInfo();
		System.out.println("board 요청 주소 path :  " + path);

		// 실제로 요청을 처리할 서비스 객체, 이안에 모든 처리 메소드 들어있음
		BoardService service = new BoardService();
		HttpSession session = request.getSession();

		// ajax / javascirpt 로 출력할 때 사용할 printWrite 객체 생성
		PrintWriter out;

		// path if문 순서 : 페이지 이동 작업 - service 전달 - ajax 작업 순으로 정렬

		/* ##########################################페이지 이동########################################## */

		if (path.equals("/csCenterPage.do") || path.equals("/listReview.do")) {
			String id = (String) session.getAttribute("memberId");
			String postCate = request.getParameter("postCate");

			if (postCate == null || postCate.equals("")) {
				postCate = "notice";
				if (path.equals("/listReview.do"))
					postCate = "review";
			}

			// 페이징 관련 작업
			int pageSize = 5; //한 페이지에 보여줄 글 개수

			int page;

			if (request.getParameter("page") == null) {
				page = 1;
			}
			else {
				page = Integer.parseInt(request.getParameter("page"));
			}

			int startRow = (page - 1) * pageSize;

			int postCount = service.countPost(postCate);

			int pageCount = postCount / pageSize + (postCount % pageSize == 0 ? 0 : 1);

			int pageBlock = 5; //한 페이지에 보여질 페이징 갯수

			int startPage = ((page / pageBlock) - (page % pageBlock == 0 ? 1 : 0)) * pageBlock + 1;
			int endPage = startPage + pageBlock - 1;

			if (endPage > pageCount)
				endPage = pageCount;

			request.setAttribute("pageCount", pageCount);
			request.setAttribute("startPage", startPage);
			request.setAttribute("endPage", endPage);
			request.setAttribute("pageBlock", pageBlock);
			request.setAttribute("postList", service.listPost(id, postCate, startRow, pageSize));

			nextPage = "../pages/defaultMain.jsp";

			if (postCate.equals("review")) {
				request.setAttribute("center", "board/listReview.jsp");
			}
			else {
				request.setAttribute("center", "board/csCenter.jsp");
			}

		}
		else if (path.equals("/postWirtePage.do")) {
			String postCate = request.getParameter("postCate");

			request.setAttribute("postCate", postCate);

			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "board/writePost.jsp");
		}
		else if (path.equals("/writeReview.do")) { // 상품 등록 페이지로 이동하는 작업
			nextPage = "../pages/defaultMain.jsp";
			request.setAttribute("center", "board/writeReview.jsp");
		}
		/* ##########################################service작업########################################## */
		else if (path.equals("/addPost.do")) {
			String writer = (String) session.getAttribute("memberId");

			Map<String, Object> postMap = upload(request, response);

			BoardBean boardBean = new BoardBean();
			List<String> fileList = (List<String>) postMap.get("fileList");

			boardBean.setPostcate((String) postMap.get("postCate"));
			boardBean.setWriter((String) postMap.get("writer"));
			boardBean.setTitle((String) postMap.get("title"));
			boardBean.setNoticecate((String) postMap.get("noticecate"));
			boardBean.setContent((String) postMap.get("content"));

			postMap.clear();

			postMap.put("boardBean", boardBean);
			postMap.put("fileList", fileList);

			service.addPost(postMap);

			nextPage = "csCenterPage.do?postCate=" + boardBean.getPostcate();

		}
		else if (path.equals("/addReview.do")) {
			String writer = (String) session.getAttribute("memberId");
			Map<String, Object> reviewMap = upload(request, response);

			BoardBean boardBean = new BoardBean();

			boardBean.setWriter(writer);
			boardBean.setScope(Integer.parseInt((String) reviewMap.get("scope")));
			boardBean.setPostcate("review");
			boardBean.setTitle((String) reviewMap.get("title"));
			boardBean.setContent((String) reviewMap.get("content"));

			List<String> fileList = (List<String>) reviewMap.get("fileList");

			int orderNo = Integer.parseInt((String) reviewMap.get("orderNo"));

			reviewMap.clear();

			reviewMap.put("boardBean", boardBean);
			reviewMap.put("fileList", fileList);
			reviewMap.put("orderNo", orderNo);

			service.addReview(reviewMap);

			nextPage = "listReview.do";

		}
		else if (path.equals("/modPost.do")) {
			String postCate = request.getParameter("postCate");
			int postNo = Integer.parseInt(request.getParameter("postno"));
			int page = Integer.parseInt(request.getParameter("page"));

			Timestamp writeDate = new Timestamp(System.currentTimeMillis());
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			String noticecate = request.getParameter("noticecate");

			BoardBean boardBean = new BoardBean(postNo, postCate, title, content, writeDate, noticecate);

			service.modPost(boardBean);

			nextPage = "readPost.do?postno=" + postNo + "&postCate=" + postCate + "&page=" + page;
		}
		else if (path.equals("/readPost.do")) {
			int postNo = Integer.parseInt(request.getParameter("postno"));
			String postCate = request.getParameter("postCate");

			System.out.println(postNo + ": " + postCate);

			Map<String, Object> postMap = service.readPost(postNo, postCate);
			List<BoardBean> answerList = service.listAnswer(postCate, postNo);

			request.setAttribute("postMap", postMap);
			request.setAttribute("answerList", answerList);

			request.setAttribute("center", "board/readPost.jsp");

			nextPage = "../pages/defaultMain.jsp";
		}
		else if (path.equals("/readReview.do")) {
			int postNo = Integer.parseInt(request.getParameter("postno"));

			Map<String, Object> reviewMap = service.readReview(postNo);

			request.setAttribute("reviewMap", reviewMap);

			request.setAttribute("center", "board/readReview.jsp");
			nextPage = "../pages/defaultMain.jsp";
		}
		/* ##########################################ajax 작업########################################## */
		else if (path.equals("/delPost.do")) {
			int postNo = Integer.parseInt(request.getParameter("postno"));
			String postCate = request.getParameter("postCate");

			boolean result = service.delPost(postNo, postCate);

			out = response.getWriter();
			out.print(result);
			out.close();

			nextPage = "../pages/defaultMain.jsp";
			return;
		}
		else if (path.equals("/download.do")) {
			download(request, response);

			return;
		}
		else if (path.equals("/addAnswer.do")) {
			String writer = (String) session.getAttribute("memberId");
			String content = request.getParameter("content");
			String answerCate = request.getParameter("answerCate");
			int answerNo = Integer.parseInt(request.getParameter("answerNo"));
			
			BoardBean boardBean = new BoardBean();
			
			boardBean.setWriter(writer);
			boardBean.setTitle("답글");
			boardBean.setPostcate("anwser");
			boardBean.setContent(content);
			boardBean.setAnswerCate(answerCate);
			boardBean.setAnswerNo(answerNo);
				
			service.addAnswer(boardBean);
			
			return;
		}
		/* ##########################################기타########################################## */

		System.out.println("nextPgae : " + nextPage);

		if (nextPage != null) {
			if (isRedirect) {
				response.sendRedirect(nextPage);
			}
			else {
				RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
				// 실제 포워딩
				dispatcher.forward(request, response);
			}
		}

	}

	public Map<String, Object> upload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map<String, Object> uploadForm = new HashMap<String, Object>();

		List<String> fileList = new ArrayList<String>();

		String encoding = "utf-8";

		String realPath = getServletContext().getRealPath("");

		File DirPath = new File(realPath.substring(0, realPath.indexOf(".metadata") - 1) + request.getContextPath() + "\\WebContent\\css\\images\\upload\\boardUpload");

		if (!DirPath.exists()) {
			DirPath.mkdirs();
		}

		DiskFileItemFactory factory = new DiskFileItemFactory();

		factory.setSizeThreshold(1024 * 1024 * 1);
		factory.setRepository(DirPath);

		ServletFileUpload upload = new ServletFileUpload(factory);

		try {
			List post = upload.parseRequest(request);

			for (int i = 0; i < post.size(); i++) {
				FileItem item = (FileItem) post.get(i);

				if (item.isFormField()) {
					uploadForm.put(item.getFieldName(), item.getString(encoding));
					System.out.println(item.getFieldName() + " : " + item.getString(encoding));
				}
				else {
					if (item.getSize() > 0) {
						int idx = item.getName().lastIndexOf("\\");

						if (idx == -1) {
							idx = item.getName().lastIndexOf("/");// -1 얻기
						}

						String OrifileName = item.getName().substring(idx + 1);

						File uploadFile = new File(DirPath + "\\" + OrifileName);

						int num = 0;
						String fileName = OrifileName;

						while (uploadFile.exists()) {
							num++;
							fileName = OrifileName.substring(0, OrifileName.indexOf(".")) + "Ver" + num + OrifileName.substring(OrifileName.indexOf("."));
							uploadFile = new File(DirPath + "\\" + fileName);
						}

						item.write(uploadFile);

						fileList.add(fileName);
					}
				}
			}

			uploadForm.put("fileList", fileList);
		} catch (Exception e) {
			System.out.println("upload 메서드에서 에러 : " + e);
		}

		return uploadForm;
	}

	private void download(HttpServletRequest request, HttpServletResponse response) {
		String fileSrc = request.getParameter("fileSrc");
		System.out.println("다운 옴 : " +fileSrc);

		try {
			fileSrc = new String(fileSrc.getBytes("UTF-8"), "UTF-8");

			String realPath = getServletContext().getRealPath("");

			File downFile = new File(realPath.substring(0, realPath.indexOf(".metadata") - 1) + request.getContextPath() + "\\WebContent\\css\\images\\upload\\boardUpload\\" + fileSrc);

			if (downFile.exists() && downFile.isFile()) {
				try {
					long fileSize = downFile.length();

					response.setContentType("application/x-msdownload");
					response.setContentLength((int) fileSize);

					String strClient = request.getHeader("user-agent");

					if (strClient.contains("MSIE") || strClient.contains("Trident")) {
						fileSrc = URLEncoder.encode(fileSrc, "UTF-8").replaceAll("\\+", "%20");
						response.setHeader("Content-Disposition", "filename=" + fileSrc + ";");
					}
					else {
						fileSrc = new String(fileSrc.getBytes("UTF-8"), "ISO-8859-1");
						response.setHeader("Content-Disposition", "attachment; filename=" + fileSrc + ";");
					}

					response.setContentType("application/download; UTF-8");
					response.setContentLength((int) fileSize);
					response.setHeader("Content-Length", String.valueOf(fileSize));
					response.setHeader("Content-Transfer-Encoding", "binary;");
					response.setHeader("Pragma", "no-cache");
					response.setHeader("Cache-Control", "private");

					byte b[] = new byte[1024];

					BufferedInputStream fin = new BufferedInputStream(new FileInputStream(downFile));

					BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());

					int read = 0;

					while ((read = fin.read(b)) > 0) {
						outs.write(b, 0, read);
					}
					outs.flush();
					outs.close();
					fin.close();
				} catch (Exception e) {
					System.out.println("Download Exception : " + e.getMessage());
				}
			}
		} catch (Exception e) {
			System.out.println("Download Exception : " + e.getMessage());
		}

	}
}