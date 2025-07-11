package kms.dao;

import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import kms.connection.ConnectionManager;
import kms.model.student;

public class studentDAO {
	private static Connection con = null;
	private static PreparedStatement ps = null;
	private static ResultSet rs = null;
	private static String sql;
	
	//insert student
	public static void addStudent(student stud){
		try {
			//call getConnection() method
			con = ConnectionManager.getConnection();
			
			//3. create statement
			sql = "INSERT INTO student(studName, studGender, studAddress, studBirthDate, parentId, studPhoto, studBirthCert) VALUES (?, ?, ?, ?, ?, ?,?)";
			ps = con.prepareStatement(sql);
		
			//get values from student object and set parameter values
			ps.setString(1, stud.getStudName());
			ps.setString(2, stud.getStudGender());
			ps.setString(3, stud.getStudAddress());
			ps.setDate(4, stud.getStudBirthDate());
			ps.setInt(5, stud.getParentId());
			ps.setBytes(6, stud.getStudPhoto());
			ps.setBytes(7, stud.getStudBirthCert());
			//4. execute query
			ps.executeUpdate();
			//5. close connection
			con.close();
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
		
		//update student by id
		public static void updateStudent(student stud){
			//complete the code here
			try {			
				//call getConnection() method
				con = ConnectionManager.getConnection();

				//3. create statement
				if (stud.getStudPhoto() != null && stud.getStudBirthCert() != null) {
		            // Update semua termasuk gambar
		            sql = "UPDATE student SET studName=?, studGender=?, studAddress=?, studBirthDate=?, parentId=?, studPhoto=?, studBirthCert=? WHERE studId=?";
		            ps = con.prepareStatement(sql);
		            ps.setString(1, stud.getStudName());
		            ps.setString(2, stud.getStudGender());
		            ps.setString(3, stud.getStudAddress());
		            ps.setDate(4, stud.getStudBirthDate());
		            ps.setInt(5, stud.getParentId());
		            ps.setBytes(6, stud.getStudPhoto());
		            ps.setBytes(7, stud.getStudBirthCert());
		            ps.setInt(8, stud.getStudId());
		        } else {
		            // Update tanpa gambar
		            sql = "UPDATE student SET studName=?, studGender=?, studAddress=?, studBirthDate=?, parentId=? WHERE studId=?";
		            ps = con.prepareStatement(sql);
		            ps.setString(1, stud.getStudName());
		            ps.setString(2, stud.getStudGender());
		            ps.setString(3, stud.getStudAddress());
		            ps.setDate(4, stud.getStudBirthDate());
		            ps.setInt(5, stud.getParentId());
		            ps.setInt(6, stud.getStudId());
		        }

				//4. execute query
				ps.executeUpdate();

				//5. close connection
				con.close();

			}catch(SQLException e) {
				e.printStackTrace();
			}
		}


		public static void deleteStudent(int id) {
		    try {
		        con = ConnectionManager.getConnection();

		        String sql = "DELETE FROM student WHERE studId = ?";
		        ps = con.prepareStatement(sql);
		        ps.setInt(1, id);

		        int rowsAffected = ps.executeUpdate();
		        if (rowsAffected == 0) {
		            System.out.println("No student deleted. ID may not exist: " + id);
		        } else {
		            System.out.println("Deleted student with ID: " + id);
		        }

		        con.close();

		    } catch (SQLException e) {
		        System.out.println("Error deleting student with ID: " + id);
		        e.printStackTrace();
		    }
		}

		
		//get student by id
		public static student getStudent(int studId) {
			
			student stud = new student();
			
			try {
				
				//call getConnection() method
				con = ConnectionManager.getConnection();
				
				//3. create statement 
				sql = "SELECT * FROM student WHERE studId = ?";
				ps = con.prepareStatement(sql);
				ps.setInt(1, studId);
				
				//4. execute query
				rs = ps.executeQuery();
				
				//process ResultSet
				if (rs.next()) {
					stud.setStudId(rs.getInt("studId"));
					stud.setStudName(rs.getString("studName"));
					stud.setStudGender(rs.getString("studGender"));
					stud.setStudAddress(rs.getString("studAddress"));
					stud.setStudBirthDate(rs.getDate("studBirthDate"));
					stud.setParentId(rs.getInt("parentId"));
					Blob blobPhoto = rs.getBlob("studPhoto");
					if (blobPhoto != null) {
					    stud.setStudPhoto(blobPhoto.getBytes(1, (int) blobPhoto.length()));
					}

					Blob blobBirthCert = rs.getBlob("studBirthCert");
					if (blobBirthCert != null) {
					    stud.setStudBirthCert(blobBirthCert.getBytes(1, (int) blobBirthCert.length()));
					}


				}
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return stud;
		}
		
		//get all student
		public static List<student> getAllStudents(){
			
			List<student> students = new ArrayList<student>();
			//complete the code here
			try {
				//call getConnection() method
				con = ConnectionManager.getConnection();

				//3. create statement 
				sql = "SELECT * FROM student";
				ps = con.prepareStatement(sql);

				//4. execute query
				rs = ps.executeQuery();

				//process ResultSet
				while(rs.next()) {		
					student stud = new student();
					stud.setStudId(rs.getInt("studId"));
					stud.setStudName(rs.getString("studName"));
					stud.setStudGender(rs.getString("studGender"));
					stud.setStudAddress(rs.getString("studAddress"));
					stud.setStudBirthDate(rs.getDate("studBirthDate"));
					stud.setParentId(rs.getInt("parentId"));
					Blob blobPhoto = rs.getBlob("studPhoto");
					if (blobPhoto != null) {
					    stud.setStudPhoto(blobPhoto.getBytes(1, (int) blobPhoto.length()));
					}

					Blob blobBirthCert = rs.getBlob("studBirthCert");
					if (blobBirthCert != null) {
					    stud.setStudBirthCert(blobBirthCert.getBytes(1, (int) blobBirthCert.length()));
					}
					students.add(stud);


				}

				//5. close connection
				con.close();

			}catch(SQLException e) {
				e.printStackTrace();
			}

			return students;
		}	
		
		//list by parentId
		
		public static List<student> getStudentsByParentId(int parentId) {
			
			List<student> students = new ArrayList<student>();
			
			try {
				con = ConnectionManager.getConnection();
				sql = "SELECT * FROM student WHERE parentId = ?";
				ps = con.prepareStatement(sql);
				ps.setInt(1, parentId);
				rs = ps.executeQuery();

				while (rs.next()) {
					student stud = new student();
					stud.setStudId(rs.getInt("studId"));
					stud.setStudName(rs.getString("studName"));
					stud.setStudGender(rs.getString("studGender"));
					stud.setStudAddress(rs.getString("studAddress"));
					stud.setStudBirthDate(rs.getDate("studBirthDate"));
					stud.setParentId(rs.getInt("parentId"));
					Blob blobPhoto = rs.getBlob("studPhoto");
					if (blobPhoto != null) {
					    stud.setStudPhoto(blobPhoto.getBytes(1, (int) blobPhoto.length()));
					}

					Blob blobBirthCert = rs.getBlob("studBirthCert");
					if (blobBirthCert != null) {
					    stud.setStudBirthCert(blobBirthCert.getBytes(1, (int) blobBirthCert.length()));
					}

					students.add(stud);
					
					
				}
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return students;
		}
		
		//count student yg register under parentId
		public static int countStudentByParent(int parentId) {
		    int count = 0;
		    try {
		        con = ConnectionManager.getConnection();
		        ps = con.prepareStatement("SELECT COUNT(*) FROM student WHERE parentId = ?");
		        ps.setInt(1, parentId);
		        rs = ps.executeQuery();
		        if (rs.next()) {
		            count = rs.getInt(1);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        try { if (rs != null) rs.close(); if (ps != null) ps.close(); if (con != null) con.close(); } catch (Exception e) {}
		    }
		    return count;
		}
		
		// count all students
		public static int countAll() {
			int count = 0;
			try {
				con = ConnectionManager.getConnection();
				sql = "SELECT COUNT(*) FROM Student";
				ps = con.prepareStatement(sql);
				rs = ps.executeQuery();
				if (rs.next()) count = rs.getInt(1);
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				try { if (rs != null) rs.close(); } catch (Exception e) {}
				try { if (ps != null) ps.close(); } catch (Exception e) {}
				try { if (con != null) con.close(); } catch (Exception e) {}
			}
			return count;
		}
		
		
		// get student by age
		// Get students by calculated age (based on birth year)
		public static List<student> getStudentsByAge(int age) {
		    List<student> students = new ArrayList<>();
		    try {
		        con = ConnectionManager.getConnection();

		        // Use SQL to calculate age by year
		        String sql = "SELECT * FROM student WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM studBirthDate) = ?";
		        ps = con.prepareStatement(sql);
		        ps.setInt(1, age);
		        rs = ps.executeQuery();

		        while (rs.next()) {
		            student stud = new student();
		            stud.setStudId(rs.getInt("studId"));
		            stud.setStudName(rs.getString("studName"));
		            stud.setStudGender(rs.getString("studGender"));
		            stud.setStudAddress(rs.getString("studAddress"));
		            stud.setStudBirthDate(rs.getDate("studBirthDate"));
		            stud.setParentId(rs.getInt("parentId"));

		            Blob blobPhoto = rs.getBlob("studPhoto");
		            if (blobPhoto != null) {
		                stud.setStudPhoto(blobPhoto.getBytes(1, (int) blobPhoto.length()));
		            }

		            Blob blobBirthCert = rs.getBlob("studBirthCert");
		            if (blobBirthCert != null) {
		                stud.setStudBirthCert(blobBirthCert.getBytes(1, (int) blobBirthCert.length()));
		            }

		            students.add(stud);
		        }
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    return students;
		}

		
		// get today's birthdays (name + date)
		public static List<student> getTodaysBirthdays() {
			List<student> birthdayList = new ArrayList<>();
			String sql = "SELECT studName, studBirthDate FROM Student WHERE TO_CHAR(studBirthDate, 'MM-DD') = TO_CHAR(SYSDATE, 'MM-DD')";

			try (Connection conn = ConnectionManager.getConnection();
			     PreparedStatement ps = conn.prepareStatement(sql);
			     ResultSet rs = ps.executeQuery()) {

				while (rs.next()) {
					student stud = new student();
					stud.setStudName(rs.getString("studName"));
					stud.setStudBirthDate(rs.getDate("studBirthDate"));
					birthdayList.add(stud);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return birthdayList;
		}

		// get today's birthdays (name + date + photo)
		public static List<student> getBirthdaysToday() throws SQLException {
			List<student> list = new ArrayList<>();
			String sql = "SELECT studName, studBirthDate, studPhoto FROM Student WHERE TO_CHAR(studBirthDate, 'MM-DD') = TO_CHAR(SYSDATE, 'MM-DD')";

			try (
				Connection con = ConnectionManager.getConnection();
				PreparedStatement ps = con.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()
			) {
				while (rs.next()) {
					student s = new student();
					s.setStudName(rs.getString("studName"));
					s.setStudBirthDate(rs.getDate("studBirthDate"));

					byte[] photoBytes = rs.getBytes("studPhoto");
					if (photoBytes != null) {
						s.setStudPhoto(photoBytes);
					}
					list.add(s);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return list;
		}
		
		// get student registered under subject the teacher teaches.
		public static int countStudentsByTeacherId(int teacherId) throws SQLException {
		    int count = 0;
		    Connection con = null;
		    PreparedStatement ps = null;
		    ResultSet rs = null;
		    try {
		        con = ConnectionManager.getConnection();
		        String sql = "SELECT COUNT(*) FROM student s " +
		                     "JOIN enrollments e ON s.STUDID = e.STUDID " +
		                     "JOIN subject sub ON e.SUBJECTID = sub.SUBJECTID " +
		                     "WHERE sub.TEACHERID = ?";
		        ps = con.prepareStatement(sql);
		        ps.setInt(1, teacherId);
		        rs = ps.executeQuery();
		        if (rs.next()) {
		            count = rs.getInt(1);
		        }
		    } finally {
		        if (rs != null) rs.close();
		        if (ps != null) ps.close();
		        if (con != null) con.close();
		    }
		    return count;
		}
		
	
		
		
		
		public static List<student> getStudentsWithoutAttendance(java.sql.Date date) {
		    List<student> list = new ArrayList<>();
		    try {
		        con = ConnectionManager.getConnection();
		        sql = "SELECT * FROM student s WHERE NOT EXISTS (" +
		              "  SELECT 1 FROM attendance a WHERE a.studId = s.studId AND a.attendanceDate = ?" +
		              ")";
		        ps = con.prepareStatement(sql);
		        ps.setDate(1, date);
		        rs = ps.executeQuery();

		        while (rs.next()) {
		            student stud = new student();
		            stud.setStudId(rs.getInt("studId"));
		            stud.setStudName(rs.getString("studName"));
		            // Add other fields as needed
		            list.add(stud);
		        }
		        con.close();
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    return list;
		}

		
		// Get students by age who don't have attendance for specific date
		public static List<student> getStudentsByAgeWithoutAttendance(int age, java.sql.Date date) {
		    List<student> students = new ArrayList<>();
		    try {
		        con = ConnectionManager.getConnection();
		        
		        // Get students by age who don't have attendance for the date
		        String sql = "SELECT s.* FROM student s " +
		                    "WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM s.studBirthDate) = ? " +
		                    "AND NOT EXISTS (" +
		                    "  SELECT 1 FROM attendance a WHERE a.studId = s.studId AND a.attendanceDate = ?" +
		                    ")";
		        
		        ps = con.prepareStatement(sql);
		        ps.setInt(1, age);
		        ps.setDate(2, date);
		        rs = ps.executeQuery();

		        while (rs.next()) {
		            student stud = new student();
		            stud.setStudId(rs.getInt("studId"));
		            stud.setStudName(rs.getString("studName"));
		            stud.setStudGender(rs.getString("studGender"));
		            stud.setStudAddress(rs.getString("studAddress"));
		            stud.setStudBirthDate(rs.getDate("studBirthDate"));
		            stud.setParentId(rs.getInt("parentId"));
		            
		            // Handle photo blob
		            Blob blobPhoto = rs.getBlob("studPhoto");
		            if (blobPhoto != null) {
		                stud.setStudPhoto(blobPhoto.getBytes(1, (int) blobPhoto.length()));
		            }
		            
		            students.add(stud);
		        }
		        con.close();
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    return students;
		}
		
}
