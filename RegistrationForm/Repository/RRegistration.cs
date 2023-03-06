using Dapper;
using RegistrationForm.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace RegistrationForm.Repository
{
    public class RRegistration : IRegistration
    {
        public IEnumerable<City> GetCity(int? StateId)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Mystring"].ToString()))
            {
                var para = new DynamicParameters();
                para.Add("@StateId", StateId);
                return con.Query<City>("GetCity", para, null, true, 0, CommandType.StoredProcedure).ToList();
            }
        }

        public IEnumerable<User> GetUserData(int? Id)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Mystring"].ToString()))
            {
                var para = new DynamicParameters();
                para.Add("@Id", Id);
                return con.Query<User>("GETUSERDEATILS", para, null, true, 0, CommandType.StoredProcedure).ToList();
            }
        }

        public IEnumerable<State> GetState(int? StateId)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Mystring"].ToString()))
            {
                var para = new DynamicParameters();
                para.Add("@StateId", StateId);
                return con.Query<State>("GetState", para, null, true, 0, CommandType.StoredProcedure).ToList();
            }
        }

        public int InsertUserData(User modal)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Mystring"].ToString()))
            {
                var para = new DynamicParameters();
                para.Add("@Id", modal.Id);
                para.Add("@Name", modal.Name);
                para.Add("@Email", modal.Email);
                para.Add("@Address", modal.Address);
                para.Add("@Phone", modal.Phone);
                para.Add("@CityId", modal.CityId);
                para.Add("@StateId", modal.StateId);
                para.Add("@ReturnValue", dbType: DbType.Int32, direction: ParameterDirection.Output);
                con.Execute("UserDataInsertUpdate", para, null, 0, CommandType.StoredProcedure);
                int MemID = para.Get<int>("ReturnValue");
                return MemID;
            }
        }
       public Response DeleteUser(int Id)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Mystring"].ToString()))
            {
                var para = new DynamicParameters();
                para.Add("@Id", Id);
                return con.Query<Response>("DeleteUser", para, null, true, 0, CommandType.StoredProcedure).FirstOrDefault();
            }
        }
    }
}