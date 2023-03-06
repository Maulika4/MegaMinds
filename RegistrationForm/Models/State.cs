using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RegistrationForm.Models
{
    public class State
    {
        public int Id { get; set; }
        public string StateName { get; set; }
    }
    public class Response
    {
        public int status { get; set; }
        public string Message { get; set; }
    }
}