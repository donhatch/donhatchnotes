Q: how to observe a deduced type during development?
A: from Scott Meyers CppCon 2014 "Type Deduction and Why You Care": https://www.youtube.com/watch?v=wQxj20X-tIU&t=1790s

  template<typename T> class TD;  // "type displayer"

  TD<T> foo;
  TD<decltype(t)> foo;

  then the compiler error will show the type

Q: how to observe a deduced type at runtime?
PA: it's really frickin hard.
  template<typename T>
  void f(const T &param) {
    using std::cout;
    cout << "T =     " << typeid(T).name() << '\n';  // show T
    cout << "param = " << typeid(param).name() << '\n';  // show param's type
  }
  - compilers report param's type as const Widget *.
  - correct type is const Widget * const &.
  wtf?
  because "takes the expression you pass it, and it's required to treat it as if it were being used to initialize a by-value parameter. which means you throw away the references, and you throw away any const and volatiles that happen to exist after that.  it is required to give you the wrong answer."

  boost has written it though.  "type id with cv retained"

  #include <boost/type_index.hpp>
  template<typename T>
  void f(const T& param) {
    using boost::typeindex::type_id_with_cvr;
    using std::cout;
    cout << "T =      "
         << type_id_with_cvr<T>().pretty_name() << '\n';
    cout << "param = "
         << type_id_with_cvr<decltype(param)>().pretty_name() << '\n';
  }
  T = Widget const*
  param = Widget const* const&





