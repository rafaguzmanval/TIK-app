
const authByEmailPwd = async (email, password) => {
  const user = await userModel.findOne({email: email}).exec();
  if (!user) throw new Error();

  if (user.password !== password) throw new Error();
  return user;
};

export default authByEmailPwd;