using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace RegistrationForm.Models
{
    public class User
    {
        public int Id { get; set; }
        [Required(ErrorMessage = "Please Enter Name")]
        public string Name { get; set; }
        [Required(ErrorMessage = "Please enter Email")]
        //[RegularExpression("^[a-zA-Z0-9_\\.-]+@([a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$", ErrorMessage = "E-mail id is not valid")]
        [DataType(DataType.EmailAddress,ErrorMessage ="Email id is not valid")]
        public string Email { get; set; }
        public string Address { get; set; }
        [Required(ErrorMessage = "Please Enter Phone Number")]
        [DataType(DataType.PhoneNumber, ErrorMessage = "Phone Number not valid")]
        public string Phone { get; set; }
        public int CityId { get; set; }
        public int StateId { get; set; }

    }
}