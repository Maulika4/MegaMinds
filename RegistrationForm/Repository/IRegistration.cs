using RegistrationForm.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RegistrationForm.Repository
{
    public interface IRegistration
    {
        int InsertUserData(User modal);
        IEnumerable<User> GetUserData(int? Id);
        IEnumerable<City> GetCity(int? StateId);
        IEnumerable<State> GetState(int? StateId);
        Response DeleteUser(int Id);
    }
}
