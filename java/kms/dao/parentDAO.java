package kms.dao;

import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;


import kms.connection.ConnectionManager;
import kms.model.parent;

public class parentDAO {
	
	private static Connection con = null;
	private static PreparedStatement ps = null;
	private static ResultSet rs = null;
	private static String sql;
	
	//insert student
	public static void addParent(parent p){
		try {
			//call getConnection() method
			con = ConnectionManager.getConnection();
			
			//3. create statement
			sql = "INSERT INTO parent( parentName, parentEmail, parentPass, parentPhone) VALUES ( ?, ?, ?, ?)";
			ps = con.prepareStatement(sql);
			
			String pass = p.getParentPass();
	        if (!pass.startsWith("$2a$")) {
	            pass = hashPassword(pass);
	        }

			
			//get values from student object and set parameter values
			ps.setString(1, p.getParentName());
			ps.setString(2, p.getParentEmail());
			ps.setString(3, pass);
			ps.setString(4, p.getParentPhone());
			
			//4. execute query
			ps.executeUpdate();
			//5. close connection
			con.close();
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
	}
		
		//update parent by id
	public static void updateParent(parent p) {
	    try {
	        // Sambung ke database
	        con = ConnectionManager.getConnection();

	        // Semak jika ada gambar
	        if (p.getParentPhoto() != null) {
	            // SQL kalau ada gambar
	            sql = "UPDATE parent SET parentName=?, parentEmail=?, parentPass=?, parentPhone=?, parentPhoto=? WHERE parentId=?";
	            ps = con.prepareStatement(sql);

	            // Semak kalau password dah hashed atau belum
	            String pass = p.getParentPass();
	            if (!pass.startsWith("$2a$")) {
	                pass = hashPassword(pass); // hash password kalau belum hash
	            }

	            // Masukkan data dalam query
	            ps.setString(1, p.getParentName());
	            ps.setString(2, p.getParentEmail());
	            ps.setString(3, pass);
	            ps.setString(4, p.getParentPhone());
	            ps.setBytes(5, p.getParentPhoto());
	            ps.setInt(6, p.getParentId());
	        } else {
	            // SQL kalau tak ada gambar
	            sql = "UPDATE parent SET parentName=?, parentEmail=?, parentPass=?, parentPhone=? WHERE parentId=?";
	            ps = con.prepareStatement(sql);

	            // Semak password
	            String pass = p.getParentPass();
	            if (!pass.startsWith("$2a$")) {
	                pass = hashPassword(pass);
	            }

	            // Masukkan data dalam query
	            ps.setString(1, p.getParentName());
	            ps.setString(2, p.getParentEmail());
	            ps.setString(3, pass);
	            ps.setString(4, p.getParentPhone());
	            ps.setInt(5, p.getParentId());
	        }

	        // Jalankan query
	        ps.executeUpdate();

	        // Tutup connection
	        con.close();

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}



		//delete
		public static void deleteParent(int parentId){
			//complete the code here
			try {			
				//call getConnection() method
				con = ConnectionManager.getConnection();

				//3. create statement
				String sql = "DELETE FROM parent WHERE parentId=?";
				ps = con.prepareStatement(sql);

				//set parameter value
				ps.setInt(1, parentId);

				//4. execute query
				ps.executeUpdate();

				//5. close connection
				con.close();

			}catch(SQLException e) {
				e.printStackTrace();
			}	

	   }
		
		//get parent by id
		public static parent getParent(int parentId) {
			parent p = new parent();
			try {
				con = ConnectionManager.getConnection();
				sql = "SELECT * FROM parent WHERE parentId = ?";
				ps = con.prepareStatement(sql);
				ps.setInt(1, parentId);
				rs = ps.executeQuery();

				if (rs.next()) {
					
			            p.setParentId(rs.getInt("parentId"));
			            p.setParentName(rs.getString("parentName"));
			            p.setParentEmail(rs.getString("parentEmail"));
			            p.setParentPass(rs.getString("parentPass"));
			            p.setParentPhone(rs.getString("parentPhone"));
			            Blob blobPhoto = rs.getBlob("parentPhoto");
						if (blobPhoto != null) {
						   p.setParentPhoto(blobPhoto.getBytes(1, (int) blobPhoto.length()));
						}

				}
				con.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
			return p;
		}
		
		//get all parent
		public static List<parent> getAllParents(){
			
			List<parent> parents = new ArrayList<parent>();
			//complete the code here
			try {
				//call getConnection() method
				con = ConnectionManager.getConnection();

				//3. create statement 
				sql = "SELECT * FROM parent ORDER BY parentId";
				ps = con.prepareStatement(sql);

				//4. execute query
				rs = ps.executeQuery();

				//process ResultSet
				while(rs.next()) {		
					parent p = new parent();
			            p.setParentId(rs.getInt("parentId"));
			            p.setParentName(rs.getString("parentName"));
			            p.setParentEmail(rs.getString("parentEmail"));
			            p.setParentPass(rs.getString("parentPass"));
			            p.setParentPhone(rs.getString("parentPhone"));
			            Blob blobPhoto = rs.getBlob("parentPhoto");
						if (blobPhoto != null) {
						   p.setParentPhoto(blobPhoto.getBytes(1, (int) blobPhoto.length()));
						}
			            
			            parents.add(p);

				}

				//5. close connection
				con.close();

			}catch(SQLException e) {
				e.printStackTrace();
			}

			return parents;
		}
		
		public static parent validate(String email, String password) {
		    parent p = null;
		    try {
		        con = ConnectionManager.getConnection();
		        sql = "SELECT * FROM parent WHERE parentEmail = ?";
		        ps = con.prepareStatement(sql);
		        ps.setString(1, email);
		        rs = ps.executeQuery();

		        if (rs.next()) {
		            String hashedPass = rs.getString("parentPass");
		            if (checkPassword(password, hashedPass)) {
		            	
		                p = new parent();
		                p.setParentId(rs.getInt("parentId"));
		                p.setParentName(rs.getString("parentName"));
		                p.setParentEmail(rs.getString("parentEmail"));
		                p.setParentPass(hashedPass);
		                p.setParentPhone(rs.getString("parentPhone"));
		                
		            }
		        }


		        con.close();
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    return p;
		}
		
		//untuk newPassword
		public static int updateParentPassword(String email, String password) {
		    int rowCount = 0;
		    try {
		        con = ConnectionManager.getConnection();
		        sql = "UPDATE parent SET parentPass = ? WHERE parentEmail = ?";
		        ps = con.prepareStatement(sql);
		        
		     // Elak double hash
		        String hashedPass = password;
		        if (!password.startsWith("$2a$")) {
		            hashedPass = hashPassword(password);
		        }
		        
		        ps.setString(1, hashedPass);
		        ps.setString(2, email);
		        rowCount = ps.executeUpdate();
		        con.close();
		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		    return rowCount;
		}
		
		// count all parents
	    public static int countAll() {
	        int count = 0;
	        try {
	            con = ConnectionManager.getConnection();
	            sql = "SELECT COUNT(*) FROM parent";
	            ps = con.prepareStatement(sql);
	            rs = ps.executeQuery();
	            if (rs.next()) {
	                count = rs.getInt(1);
	            }
	            con.close();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	        return count;
	    }
	    
	    public static void updatePassword(int parentId, String newPassword) {
	        try (Connection con = ConnectionManager.getConnection();
	             PreparedStatement ps = con.prepareStatement("UPDATE parent SET parentPass = ? WHERE parentId = ?")) {

	            // Hash the password first if it's not already hashed
	            String hashedPass = newPassword;
	            if (!newPassword.startsWith("$2a$")) {
	                hashedPass = hashPassword(newPassword);
	            }

	            ps.setString(1, hashedPass);
	            ps.setInt(2, parentId);
	            ps.executeUpdate();
	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
	    }


		
	 // hash password
		private static String hashPassword(String plainTextPassword) {
		    return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
		}
		
		 // check hashed password
		private static boolean checkPassword(String plainTextPassword, String hashedPassword) {
		    return BCrypt.checkpw(plainTextPassword, hashedPassword);
		}


}
